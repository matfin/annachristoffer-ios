//
//  ProjectController.m
//  Anna Christoffer
//
//  Created by Matthew Finucane on 23/03/2015.
//  Copyright (c) 2015 Anna Christoffer. All rights reserved.
//

#import "ProjectController.h"
#import "CategoryController.h"
#import "ProjectCategory.h"

static ProjectController *sharedInstance = nil;
static NSString *coredataCacheName = @"projects";

@interface ProjectController () <CategoryControllerDelegate>
@property (nonatomic, strong) NSArray *categories;
@end

@implementation ProjectController

@synthesize categories;

- (id)init {
    if(self = [super init]) {
        self.environmentDictionary = [Environment sharedInstance].environmentDictionary;
        [[CategoryController sharedInstance] setDelegate:self];
    }
    return self;
}

+ (ProjectController *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark - Fetching and saving data from the endpoint

- (void)startFetchingProjectData {
    /**
     *  We need the categories first, so start fetching these
     */
    [[CategoryController sharedInstance] fetchEndpointDataWithKey:@"categories"];
}

- (void)categoryDataFetchedAndStored {
    self.categories = [[CategoryController sharedInstance] fetchCategories];
    /**
     *  When the categories have been fetched and stored, start fetching the projects
     */
    [self fetchEndpointDataWithKey:@"projects"];
}


- (void)saveFetchedData:(NSData *)data {
    
    NSError *jsonError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if(jsonError != nil) {
        //TODO: Handle json parse error
        return;
    }
    
    NSArray *results = [parsedObject valueForKey:@"items"];
    
    for(NSDictionary *projectDictionary in results) {
        
        /**
         *  Checking to see if the project already exists before saving it
         */
        NSNumber *persistentID = [NSNumber numberWithInteger:[projectDictionary[@"id"] intValue]];
        
        if([self managedObjectExistsWithEntityName:@"Project" andPredicate:[NSPredicate predicateWithFormat:@"SELF.persistentID == %ld", [persistentID longLongValue]]]) continue;
        
        [self saveProject:projectDictionary];
    }
    
    /**
     *  Delegate project fetch and store success.
     */
    [self.delegate projectDataFetchedAndStored];
}

- (void)saveProject:(NSDictionary *)projectDictionary {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *baseUrl = [[[Environment sharedInstance] environmentDictionary] objectForKey:@"baseURL"];
    
    /**
     *  Entity description for the Project managed object model
     */
    NSEntityDescription *projectEntity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
    Project *project = [[Project alloc] initWithEntity:projectEntity insertIntoManagedObjectContext:self.managedObjectContext];
    project.persistentID = @([projectDictionary[@"id"] integerValue]);
    project.dateCreated = [dateFormatter dateFromString:projectDictionary[@"date_created"]];
    
    /**
     *  Call the function to save the basic content to the project,
     *  things like the title and description
     */
    [self attachMessageCodesToManagedObject:project withContentDictionary:projectDictionary andContentKeys:@[@"title", @"description"]];
    
    /**
     *  Entity description for the Image managed object model - the projects thumbnail image
     */
    NSEntityDescription *imageEntity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    Image *image = [[Image alloc] initWithEntity:imageEntity insertIntoManagedObjectContext:self.managedObjectContext];
    
    /**
     *  Use a predicate filter on the contents dictionary to pull out the thumbnail image for the project
     */
    NSPredicate *thumbnailFilterPredicate = [NSPredicate predicateWithFormat:@"type MATCHES %@", @"thumbnail"];
    NSArray *filteredThumbnailContents = [[projectDictionary objectForKey:@"contents"] filteredArrayUsingPredicate:thumbnailFilterPredicate];
    
    /**
     *  Grab the result and assign it to the image, then assign the image to the project
     */
    if([filteredThumbnailContents count] > 0) {
        NSString *imagePath = [[filteredThumbnailContents objectAtIndex:0] objectForKey:@"img"];
        image.url = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, @"images/projects/",imagePath, @"@2x.jpg"];
        [project setThumbnail:image];
    }
    
    /**
     *  Now we need to fetch captions and add them to the project
     */
    [self attachCaptionsToProject:project withContentDictionary:projectDictionary];
    
    /**
     *  Then we need to associate the project with its categories
     */
    [self attachCategoriesToProject:project withContentDictionary:projectDictionary];
    
    /**
     *  Then save everything
     */
    NSError *projectSaveError = nil;
    if(![self.managedObjectContext save:&projectSaveError]) {
        //TODO: Could not save the project - handle this error
    }
}

- (void)attachCategoriesToProject:(Project *)project withContentDictionary:(NSDictionary *)contentDictionary {
    NSDictionary *categoryIdsDictionary = [contentDictionary objectForKey:@"category_ids"];
    for(NSDictionary *categoryIdDictionary in categoryIdsDictionary) {
        NSNumber *categoryID = [NSNumber numberWithInteger:[[categoryIdDictionary valueForKey:@"id"] integerValue]];
        ProjectCategory *category = [[CategoryController sharedInstance] fetchCategoryWithPersistentID:categoryID];
        
        /**
         *  Assign the fetched category to the project
         */
        if(category != nil) {
            [project addCategoriesObject:category];
        }
    }
}

- (void)attachCaptionsToProject:(Project *)project withContentDictionary:(NSDictionary *)contentDictionary {
    
    /**
     *  Setting up the entity for the caption
     */
    NSEntityDescription *captionEntity = [NSEntityDescription entityForName:@"Caption" inManagedObjectContext:self.managedObjectContext];
   
    NSPredicate *captionFilterPredicate = [NSPredicate predicateWithFormat:@"type MATCHES %@", @"figcaption"];
    NSArray *filteredCaptionContents = [[contentDictionary objectForKey:@"contents"] filteredArrayUsingPredicate:captionFilterPredicate];
    if([filteredCaptionContents count] > 0) {
        for(NSDictionary *captionDictionary in filteredCaptionContents) {
            
            Caption *caption = [[Caption alloc] initWithEntity:captionEntity insertIntoManagedObjectContext:self.managedObjectContext];
            [self attachContentToCaption:caption withCaptionDictionary:captionDictionary];
            
            /**
             *  Adding many projects to a caption will give rise to an unfixes
             *  core data bug, so we need to do this the other way around.
             */
            caption.project = project;
        }
    }
}

- (void)attachContentToCaption:(Caption *)caption withCaptionDictionary:(NSDictionary *)captionDictionary {
    
    /**
     *  Setting up the entities we need
     */
    NSEntityDescription *messageCodeIndentity = [NSEntityDescription entityForName:@"MessageCode" inManagedObjectContext:self.managedObjectContext];
    NSEntityDescription *captionImageEntity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    NSEntityDescription *sliderEntity = [NSEntityDescription entityForName:@"Slider" inManagedObjectContext:self.managedObjectContext];
    
    /**
     *  Pulling out content we need
     */
    NSDictionary *captions = [captionDictionary objectForKey:@"captions"];
    NSString *imageUrl = [captionDictionary objectForKey:@"img"];
    NSDictionary *slides = [captionDictionary objectForKey:@"slides"];
    
    /**
     *  Checking to see if we have captions and if we do, llop through and create message codes
     */
    if(captions != nil) {
        for(NSDictionary *captionContent in captions) {
            
            NSDictionary *content = [captionContent objectForKey:@"content"];
            
            NSArray *contentKeys = [content allKeys];
            for(NSString *key in contentKeys) {
                MessageCode *captionMessageCode = [[MessageCode alloc] initWithEntity:messageCodeIndentity insertIntoManagedObjectContext:self.managedObjectContext];
                
                captionMessageCode.languageCode = key;
                captionMessageCode.messageContent = [content objectForKey:key];
                captionMessageCode.messageKey = @"content";
                /**
                 *  We need to associate the child with the parent. 
                 *  Doing this the other way around causes a bug in 
                 *  CoreData to crash the app.
                 */
                captionMessageCode.caption = caption;
            }
        }
    }
    /**
     *  Checking to see if we have an image and if we do, attaching it
     */
    if(imageUrl != nil) {
        Image *captionImage = [[Image alloc] initWithEntity:captionImageEntity insertIntoManagedObjectContext:self.managedObjectContext];
        NSString *baseUrl = [self.environmentDictionary objectForKey:@"baseURL"];
        captionImage.url = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, @"images/projects/", imageUrl, @"@2x.jpg"];
        /**
         *  We need to associate the child with the parent.
         *  Doing this the other way around causes a bug in
         *  CoreData to crash the app.
         */
        caption.image = captionImage;
        caption.captionType = [NSNumber numberWithInt:captionTypeImage];
    }
    
    /**
     *  Checking to see if we have slides, and if so, attaching them
     */
    if(slides != nil) {
        Slider *slider = [[Slider alloc] initWithEntity:sliderEntity insertIntoManagedObjectContext:self.managedObjectContext];
        /**
         *  Grab the images for the slider
         */
        for(NSDictionary *slideDictionary in slides) {
            Image *slideImage = [[Image alloc] initWithEntity:captionImageEntity insertIntoManagedObjectContext:self.managedObjectContext];
            NSString *baseUrl = [self.environmentDictionary objectForKey:@"baseURL"];
            NSString *slideImagePath = [slideDictionary objectForKey:@"img"];
            slideImage.url = [NSString stringWithFormat:@"%@%@%@%@", baseUrl, @"images/projects/", slideImagePath, @"@2x.jpg"];
            slideImage.slider = slider;
        }
        /**
         *  Then assign it to the caption
         */
        caption.captionType = [NSNumber numberWithInt:captionTypeSlider];
        caption.slider = slider;
    }
}

#pragma mark - Returning data from the CoreData store

- (void)filterProjectsWithCategory:(ProjectCategory *)category {
    if(self.fetchRequest == nil) {
        self.fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
        [self.fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]]];
    }
    
    if(category != nil) {
        [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY categories.persistentID = %ld", [category.persistentID longLongValue]]];
    }
    else {
        [self.fetchRequest setPredicate:nil];
    }
    
    [NSFetchedResultsController deleteCacheWithName:coredataCacheName];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:coredataCacheName];
    
    NSError *fetchError = nil;
    
    [self.fetchedResultsController performFetch:&fetchError];
    
    if(fetchError == nil) {
        //TODO: Manage this fetch error
    }
}

#pragma mark - Cleanup

- (void)cleanupFetchedResultsController {
    [self.fetchedResultsController setDelegate:nil];
    [self setFetchedResultsController:nil];
    [self setFetchRequest:nil];
}

@end
