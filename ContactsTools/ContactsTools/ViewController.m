//
//  ViewController.m
//  ContactsTools
//
//  Created by Alex Yu on 1/29/15.
//  Copyright (c) 2015 no. All rights reserved.
//

#import "ViewController.h"
#import "NSString+ChineseCharater.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface ViewController ()
{
    ABAddressBookRef addressBook;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, NULL);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)startToSeparateNameAndAddPhonetic:(id)sender {
    [self separateFisrtNameAndLastName];
    [self addPhoneticForContacts];
}


- (void)separateFisrtNameAndLastName
{
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    printf("Retrieved %lu contacts\n",(unsigned long)[array count]);
    
    for (int i = 0; i< [array count]; i++) {
        ABRecordRef record = (__bridge ABRecordRef)([array objectAtIndex:i]);
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName  = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        NSString *wholeName;
        
        if ((lastName.length == 0) && ([firstName isAllChinesseCharactor]) && (![firstName isLikeAName])) {
            NSLog(@"firstName %@ 不像是个名字！", firstName);
        }
        
        if ((firstName.length == 0) && ([lastName isAllChinesseCharactor]) && (![lastName isLikeAName])) {
            NSLog(@"lastName %@ 不像是个名字！", lastName);
        }
        
        if ((lastName.length == 0) && ([firstName isAllChinesseCharactor]) && [firstName isLikeAName]) {
            wholeName = [firstName copy];
            lastName = [wholeName substringToIndex:1];
            firstName = [wholeName substringFromIndex:1];
            CFErrorRef error;
            ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)firstName, &error);
            ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFTypeRef)lastName, &error);
        }
        
        if ((firstName.length == 0) && ([lastName isAllChinesseCharactor]) && [lastName isLikeAName]) {
            wholeName = [lastName copy];
            lastName = [wholeName substringToIndex:1];
            firstName = [wholeName substringFromIndex:1];
            CFErrorRef error;
            ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)firstName, &error);
            ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFTypeRef)lastName, &error);
        }
    }
}

- (void)addPhoneticForContacts
{
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    printf("Retrieved %lu contacts\n",(unsigned long)[array count]);
    
    for (int i = 0; i< [array count]; i++) {
        ABRecordRef record = (__bridge ABRecordRef)([array objectAtIndex:i]);
        
        NSString *firstName =(__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName =(__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        if ([firstName isAllChinesseCharactor]) {
            
            NSString *tempString = [firstName getPinyinWithoutBlankSpace];
            tempString = tempString.capitalizedString;
            CFTypeRef tempType = (__bridge CFTypeRef)(tempString);
            
            CFErrorRef error;
            ABRecordSetValue(record, kABPersonFirstNamePhoneticProperty, tempType, &error);
            
            //            NSString *firstNamePhonetic = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty);
            //            NSLog(@"%@", firstNamePhonetic);
        }
        
        if ([lastName isAllChinesseCharactor]) {
            NSString *tempString = [lastName getPinyinWithoutBlankSpaceEspeciallyForLastName];
            tempString = tempString.capitalizedString;
            CFTypeRef tempType = (__bridge CFTypeRef)(tempString);
            
            CFErrorRef error;
            ABRecordSetValue(record, kABPersonLastNamePhoneticProperty, tempType, &error);
            
            //            NSString *lastNamePhonetic = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty);
            //            NSLog(@"%@", lastNamePhonetic);
        }
    }
    
    CFErrorRef error = nil;
    ABAddressBookSave(addressBook, &error);
    if (error) {
        NSLog(@"%ld, %@", CFErrorGetCode(error), CFErrorGetDomain(error));
    }
}

@end