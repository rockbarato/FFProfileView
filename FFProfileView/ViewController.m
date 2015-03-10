//
//  ViewController.m
//  FFProfileView
//
//  Created by Felix Ayala on 3/3/15.
//  Copyright (c) 2015 Felix Ayala. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"

#define kImagePreferenceKey @"avatar-profile"
#define kDefaultProfileImage @"baby"
#define kAnimationDuration 0.5f

@interface ViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *changeAvatarButton;


@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self configureProfileView];
	[self reflectBackgroundImage];
}

- (void)configureProfileView {
	
	self.avatarProfileImage.layer.cornerRadius = self.avatarProfileImage.frame.size.width / 2;
	self.avatarProfileImage.layer.borderWidth = 3.0f;
	self.avatarProfileImage.layer.borderColor = [UIColor whiteColor].CGColor;
	self.avatarProfileImage.clipsToBounds = YES;
	self.avatarProfileImage.contentMode = UIViewContentModeScaleAspectFill;
	self.avatarProfileImage.userInteractionEnabled = YES;
	self.avatarProfileImage.multipleTouchEnabled = YES;
	
	// Si existe una imagen guardada, la seteamos
	if ([self getPreference:kImagePreferenceKey] != nil) {
		[self.avatarProfileImage setImage:[self getPreference:kImagePreferenceKey]];
	} else {
		[self.avatarProfileImage setImage:[UIImage imageNamed:kDefaultProfileImage]];
	}
	
	[self addTapGestureToAvatar];
	
	self.backgroundProfileImage.contentMode = UIViewContentModeScaleAspectFill;
	self.backgroundProfileImage.clipsToBounds = YES;
}

// Reflect Avatar Profile content into Background View
- (void)reflectBackgroundImage {
	UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.2];
	
	self.backgroundProfileImage.image = [self.avatarProfileImage.image applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (void)addTapGestureToAvatar {
	
	UITapGestureRecognizer *changeAvatarGestureAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar:)];
	[self.avatarProfileImage addGestureRecognizer:changeAvatarGestureAvatar];
	
	UITapGestureRecognizer *changeAvatarGestureButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar:)];
	[self.changeAvatarButton addGestureRecognizer:changeAvatarGestureButton];
}

- (void)changeAvatar:(UITapGestureRecognizer *)recognizer {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Elige una imagen de avatar"
															 delegate:self
													cancelButtonTitle:@"Cancelar"
											   destructiveButtonTitle:@"Eliminar Imagen Actual"
													otherButtonTitles:@"Tomar una foto", @"Elegir de la galería", nil];
	
	[actionSheet showInView:self.view];
}

// Make status bar light
- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - UIActionSheet Delegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {\
	
	if (buttonIndex == 0) {
		
		[self removePreference:kImagePreferenceKey];
		
		[UIView transitionWithView:self.avatarProfileImage
						  duration:kAnimationDuration
						   options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionLayoutSubviews
						animations:^{
							[self.avatarProfileImage setImage:[UIImage imageNamed:kDefaultProfileImage]];
							[self reflectBackgroundImage];
						} completion:nil];
		
	} else if (buttonIndex == 1) {
		
		if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[[[UIAlertView alloc] initWithTitle:@"Atención!" message:@"Este dispositivo no posee cámara integrada." delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles:nil] show];
		} else {
			
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			
			[self presentViewController:picker animated:YES completion:NULL];
		}
		
	} else if (buttonIndex == 2) {
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		[self presentViewController:picker animated:YES completion:NULL];
	}
	
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
	
	[UIView transitionWithView:self.avatarProfileImage
					  duration:kAnimationDuration
					   options:UIViewAnimationOptionTransitionCrossDissolve
					animations:^{
						[self.avatarProfileImage setImage:chosenImage];
						[self reflectBackgroundImage];
					} completion:nil];
	
	[self setPreference:chosenImage forKey:kImagePreferenceKey];
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - User Preferences
- (void)setPreference:(id)anObject forKey:(NSString *)aKey {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:anObject];
	[userDefaults setObject:data forKey:aKey];
	[userDefaults synchronize];
}

- (id)getPreference:(NSString *)aKey {
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:aKey];
	
	if (data != nil) {
		return [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	
	return nil;
}

- (void)removePreference:(NSString *)aKey {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults removeObjectForKey:aKey];
	[userDefaults synchronize];
}

@end