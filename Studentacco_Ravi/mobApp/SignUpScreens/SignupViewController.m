//
//  SignupViewController.m
//  StudentAcco
//
//  Created by MAG  on 6/27/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "SignupViewController.h"
#import "MFSideMenu.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "UserDetail.h"
#import "CustomTextFieldTableViewCell.h"
#import "GenderSelectionTableViewCell.h"
#import "SignUpButtonTableViewCell.h"
#import "ProfilePictureTableViewCell.h"
#import "BlankTableViewCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "TermConditionTableViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#define kCustomTextFieldTableViewCell @"customTextFieldTableViewCell"
#define kGenderSelectionTableViewCell @"genderSelectionTableViewCell"
#define kTermConditionTableViewCell   @"termConditionTableViewCell"
#define kProfilePictureTableViewCell  @"profilePictureTableViewCell"
#define kBlankTableViewCell          @"BlankTableViewCell"
@interface SignupViewController ()<ConnectionDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *userType;
    NSString *userFirstName;
    NSString *userLastName;
    NSString *userMobile;
    NSString *userEmail;
    NSString *userPassword;
    NSString *userConfirmPassword;
    NSString *dob;
    NSString *userGender;
    NSString *userStreet;
    NSString *userCity;
    NSString *userState;
    NSString *userCountry;
    NSString *addressline1;
    NSString *addressline2;
    NSString *userPincode;
    NSString *userEducation;
    NSString *imageData;
    UserDetail *userDetail;
    NSString *fName,*lNmae;
    NSURL *imgURL;
    NSDictionary *userdetails;
    __weak IBOutlet UITableView *registrationTableView;
    
    NSArray *registrationFormList;
    BOOL    isAgreeTermsCondition;
    NSString *genderSelection;
    NSArray *userTypeArray;
    NSArray *userEducationArray;
    NSMutableArray *userCityArray;
    NSMutableArray *userStateArray;
    NSMutableArray *userCountryArray;
    
    NSArray *pickerArray;
    UIPickerView *pickerView;
    NSIndexPath *selectedIndexPath;
    NSString *emailId,*requestFor,*otp;
    __weak IBOutlet UIView *termsConditionView;
    __weak IBOutlet UITextView *termsConditionTextView;
    
    // Date Picker
    __weak IBOutlet UIView *datePickerView;
    __weak IBOutlet UIDatePicker *datePicker;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePicture;
@end

@implementation SignupViewController
@synthesize userSocialLoginData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    registrationFormList = @[@"User Type", @"First Name", @"Last Name", @"Mobile Number", @"Email", @"Password", @"Retype Password", @"Profile Picture", @"Date of Birth", @"Gender", @"Country", @"State", @"City", @"Address", @"", @"Pincode", @"Education"];
//
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    
    NSLog(@"Social Login Data is.....%@",userSocialLoginData);
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
    
    userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    registrationFormList = @[@"User Type", @"First Name*",@"Last Name*",@"Email*",@"10 Digit Mobile Number*"];
    userTypeArray = @[@"Student",@"Property Owner",@"Broker"];
    
    userEducationArray = @[@"Select Education",@"Post Graduate",@"Graduate",@"Intermediate",@"Matriculation"];
    
    userCountryArray = @[@"Select Country",@"Iceland",@"India",@"Indonesia",@"Iran",@"Iraq"].mutableCopy;
    userStateArray = @[@"Select State",@"Andaman and Nicobar Island",@"Andhra Pradesh",@"Assam",@"Bihar",@"Delhi"].mutableCopy;
    userCityArray = @[@"Select City",@"Central Delhi",@"East Delhi",@"New Delhi",@"North Delhi",@"South Delhi"].mutableCopy;
    
    userType = userTypeArray[0];
    userCountry = userCountryArray[0];
    userState = userStateArray[0];
    userCity = userCityArray[0];
    userEducation = userEducationArray[0];
    
    [registrationTableView registerNib:[UINib nibWithNibName:@"CustomTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:kCustomTextFieldTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"GenderSelectionTableViewCell" bundle:nil] forCellReuseIdentifier:kGenderSelectionTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"TermConditionTableViewCell" bundle:nil] forCellReuseIdentifier:kTermConditionTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"ProfilePictureTableViewCell" bundle:nil] forCellReuseIdentifier:kProfilePictureTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"BlankTableViewCell" bundle:nil] forCellReuseIdentifier:kBlankTableViewCell];
    
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 200)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.hidden = YES;
    pickerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:pickerView];
    
    [self hideTermsCondition:nil];
    registrationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    registrationTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,1,40)];
//     [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    [[NSNotificationCenter defaultCenter]addObserver:self
selector:@selector(show:) name:SignUpNotification object:nil];;
    
}

-(void)show:(NSNotification *) notification
{
    
    NSLog(@"Data is....%@",[notification object]);
    SignupViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic=[notification object];
    obj.userSocialLoginData=dic;
    [self.navigationController pushViewController:obj animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (IBAction)hideTermsCondition:(id)sender {
    
    termsConditionView.hidden = YES;
}
#pragma terms and condition;
- (void)showTermCondition {
    
    termsConditionView.hidden = NO;
    
    NSString *strTemp = @"<html><head></head>\
    <body>\
    <div><h1>Terms</h1></div>\
    <div>\
    <p ><b>This document is an electronic record in terms of the Information Technology Act, 2000, and rules there under, as applicable, and the amended provisions pertaining to electronic records in various statutes as amended by the Information Technology Act, 2000. This electronic record is generated by a computer system and does not require any physical or digital signatures.</b></p>\
    <p><b>This document is published in accordance with the provisions of Rule 3(1) of the Information Technology (Intermediaries guidelines) Rules, 2011, that require publishing the rules and regulations, privacy policy and user agreement for access or usage of <a href=\"http://studentacco.com\"> <strong>http://studentacco.com</strong></a>.</b></p>\
    <p >We are a real estate information service connecting people in the real estate market. <b>Studentacco.com</b> and our subsidiaries and affiliates (collectively \"Studentacco.com\") provide you with access to a variety of services, including but not limited to the www.Studentacco.com website (the \"Website\") and Studentacco.com's mobile applications and all the products and services available through our website (collectively the \"Services\"). These Terms of Use govern access to and use of Studentacco.com's Services. This Website is owned and operated by M/s Viaan Technologies Private Limited, a company incorporated under the Indian Companies Act, 1956, and having its principal place of business at D-5 Sector 10, Noida-201301, Uttar Pradesh, India.</p>\
    <p>You are allowed to use our Services only if you can form a binding contract with us, and only in compliance with our Terms of Use and all applicable laws. The following terms and conditions apply to everyone who uses Studentacco.com's Services (including property owners, students and real estate service providers), and they govern the relationship between Studentacco.com and our users during their use of Studentacco.com's Services.</p>\
    <p>Please read these Terms carefully before using our Services. By accessing and using our Services, you explicitly agree to comply with and be bound by our Terms of Use and Privacy Policy.</p>\
    <p style=\"margin-top:15px;\"><h3>The Services We Provide</h3></p>\
    <p><span style=\"text-decoration:underline;\">Our Services:</span> Our Services comprise a variety of real estate-related products and services made available through our Website and Studentacco.com mobile application. These Services include but are not limited to property rental listings and related information, real estate service provider profiles, advertisements. The Services may sometimes be located on third-party websites or applications, either as links from an add-on service to, or otherwise in connection with, websites or applications that those third parties control. Our Services also include paid products and services. By purchasing or using our paid products and services, you agree to these Terms of Use.</p>\
    <p style=\"margin-top:15px;\"><h3>Registration and Use</h3></p>\
    <p><span style=\"text-decoration:underline;\">Registration:</span> Studentacco.com may require that you register in order to use some or all of the features and functionalities of the Website. We may, in our sole discretion, permit or deny your registration. Once we permit you to register with the Website, you agree and undertake to access the Website only using the unique username and password, as amended by you from time to time, associated with your registration. You will be solely responsible for maintaining the confidentiality of such password and agree that the password is intended for use solely by you. We may permit you to register with the Website using your Facebook or Twitter account. If you complete the Registration via Facebook or Twitter, all applicable Facebook and Twitter terms of use and any changes to the same shall apply to you in addition to these Terms of Use.</p>\
    <p>You understand that for the purpose of effectively using the Website you may be required to provide accurate information including but not limited to your name, address, mobile number and e-mail id (collectively referred to as “User Content”). You represent that you have all rights required to provide the information that you have provided to the Website, including the User Content and represent that they are true and accurate.</p>\
    <p>You agree and understand that this Website and the contents are intended for people who are 18 years of age or above. You hereby represent that you are 18 years of age or above and competent to contract within the meaning of section 11 of the Indian Contract Act, 1872.</p>\
    <p><span style=\"text-decoration:underline;\">Be Honest With Us:</span> The information we collect from users of our Services, including during the registration process for our users (including real estate service providers) is detailed in our privacy policy. When you create an account, you must provide us with accurate and up-to-date information, for which you are solely responsible.</p>\
    <p>If you are registering as a real estate service provider, you represent that you are duly authorized to register and by accepting these Terms of Use you bind such underlying business entity to these Terms of Use.</p>\
    <p>You will be solely responsible for your acts on the Website including those conducted under the username assigned to you. You understand and agree that Studentacco.com may, in our sole discretion, terminate your access to the Website without notice and you waive any right to claim access to the Website or any other claim that you may have. Any data of your usage may be retained or deleted at Studentacco.com’s sole discretion. You agree that the User Content uploaded can be used and viewed by other third parties who access the Website.</p>\
    <p>By using our Services and providing us with your contact information, you agree that we can send you communications about our Services. By using our Services or by filling out any forms/agreements on or through the Services, providing us with information or making an inquiry, you acknowledge that we have an established business relationship with you and you expressly consent to being contacted by us or our service providers, whether by phone, mobile phone, text (SMS), email, postal mail or otherwise. From time to time, when you call us we may wish to record those phone calls for quality assurance and customer satisfaction purposes. In those jurisdictions where consent is required in order for a party to record any telephone call, you consent for us to record your call when you call us.</p><p>All User Content will be used and processed in accordance with these Terms of Use and the Privacy Policy. You agree that you have read and understood the Privacy Policy.</p>\
    <p><span style=\"text-decoration:underline;\">Permitted Use:</span> You agree that you will use the Website only for the purposes of viewing or listing advertisements related to real estate such as commercial listings, rental listings, paying-guest listings and hostel listings or to use the other services provided by Studentacco.com through our Website and mobile applications in accordance with these Terms of Use and all other applicable agreements that you have entered into with Studentacco.com.</p>\
    <p>You will use the Website and any information available in accordance with all applicable laws and regulations. These Terms of Use are in addition to and not in derogation of any other agreements or terms and conditions agreed upon or entered into by you.</p>\
    <p><span style=\"text-decoration:underline;\">Prohibited Use:</span> In relation to the use and access of the Website its content and features, you agree and undertake not to:</p>\
    <ul>\
    <li>Other than when acting as a real estate developer, property manager or real estate broker list advertisements related to real estate such as residential listings, commercial listings, rental listings, paying-guest listings, hostel listings and service apartment listings on the Website, upload, transmit or publish any information on behalf of a third party, including any User content of any person other than you, and more specifically, you will not impersonate another person;</li>\
    <li>Upload, transmit or publish any information or material which is threatening, abusive, obscene, derogatory (in any form), defamatory or libelous, discriminatory, racially or ethnically objectionable or contains pornography;</li>\
    <li>Violate the privacy or publish any personal information of any person except to the extent specifically approved by such person and only to the extent absolutely necessary to advertise such real estate property;</li>\
    <li>Upload, transmit or publish any viruses or other malware to corrupt, interrupt, limit, destroy or otherwise impact the Website, Studentacco.com’s computer systems or the computer systems of other users or third party systems;</li>\
    <li>Upload transmit or publish anything which you do not have the rights to or any material which infringes on the intellectual property rights (in whatever form) of any third party;</li>\
    <li>Use the Website in any manner which is not permitted under these Terms of Use or in any manner which is illegal or unethical;</li>\
    <li>Access the Website in any unauthorized manner, including by hacking or using log in credentials of any other user; and</li>\
    <li>Use the Website for any unauthorized marketing purposes or for sending any unsolicited materials.</li>\
    </ul>\
    <p>If any of your actions on the Website or materials posted by you on the Website are flagged as inappropriate, Studentacco.com reserves the right to review such actions or content to determine, in our sole and absolute discretion, whether it violates these Terms of Use. If Studentacco.com removes your content or disables your account and/or access to the Website, you may assume that such removal or disablement was purposeful on the part of Studentacco.com. Studentacco.com may additionally refuse to let you re-register and/or use the features and functionalities of the Website in our sole discretion.</p>\
    <p>Deal with Us in Good Faith: By creating an account, you agree that you are signing up for Studentacco.com's Services in good faith, and that you mean to use them only for their intended purposes as real estate information tools and for no other reason.</p>\
    <p><span style=\"text-decoration:underline;\">Security:</span> While Studentacco.com works to protect the security of your content and account, we cannot guarantee that unauthorized third parties will not be able to circumvent our security measures. Please notify us immediately in the event of any compromise or unauthorized use of your account. You are also responsible for maintaining the confidentiality of your account information and for ensuring that only authorized individuals have access to your account. You are responsible for all actions taken or content added through your account.</p>\
    <p>By using certain of our Services, you agree that Studentacco.com may create a user account for you. You can learn about our policies for data collected via user accounts in our privacy policy. Like all our accounts, you may delete it at any time.</p>\
    <p style=\"margin-top:15px;\"><h3>Our Rules About Your Data Privacy</h3></p>\
    <p>Studentacco.com's Privacy Policy Governs Our Collection, Use, and Disclosure of Your Data: Our privacy policy governs our collection, use, and disclosure of your personal information and is incorporated into these Terms of Use. Please read it carefully. It describes what information we collect from you and when, how and why we may create an account for you, whom we share your information with and when and how you can opt-out or delete your account. This is important information. By using our Services, you consent to our Privacy Policy.</p>\
    <p style=\"margin-top:15px;\"><h3>Our Rules About Your Content</h3></p>\
    <p>Your Content Is Your Responsibility: You are solely responsible for any messages, reviews, text, photos, videos, graphics, code, or other information, content or materials that you post, submit, publish, display or link to through the Services or send to other Studentacco.com users.</p>\
    <p>Studentacco.com May Choose to Monitor User Content: Studentacco.com does not approve, control, or endorse your or anyone else's User Content and has no obligation to do so. However, we reserve the right (but assume no obligation) to remove or modify User Content for any reason, at our sole discretion, including User Content that we believe violates our Terms of Use.</p>\
    <p><span style=\"text-decoration:underline;\">Be Truthful:</span> You agree to provide accurate, complete, current, and truthful information when you add or edit facts about your home or otherwise provide content via the Services.</p>\
    <p>Do Not Post Illegal or Harmful Content: You agree not to post, submit, or link to any User Content or material that infringes, misappropriates, or violates the rights of any third party (including intellectual property rights) or that is in violation of any federal, state, or local law, rule, or regulation. You also agree not to post, submit or link to any User Content that is defamatory, obscene, pornographic, indecent, harassing, threatening, abusive, inflammatory, or fraudulent, purposely false or misleading or otherwise harmful.</p>\
    <p><span style=\"text-decoration:underline;\">Do Not Violate Others' Rights:</span> You agree not to post copyrighted material without permission from the owner of the copyright. This includes, for example, photographs or other content you upload via the Services. You also agree not to disclose confidential or sensitive information. This includes but is not limited to information about neighbors or other information that would potentially be viewed as an invasion of privacy.</p>\
    <p ><span style=\"text-decoration:underline;\">You Grant Studentacco.com a License to Use Your Content:</span> When you provide User Content via our Services, you grant Studentacco.com a royalty-free, perpetual, irrevocable, and license worthy of sub-license to publish, reproduce, distribute, display, adapt, modify and otherwise use your User Content in connection with our Services. We will not pay you or otherwise compensate you for the content you provide to us.</p>\
    <p ><span style=\"text-decoration:underline;\">Your Content May Be Made Public:</span> You understand and agree that any User Content that you post or submit to Studentacco.com may be redistributed through the Internet and other media channels, and may be viewed by the general public.</p>\
    <p >We reserve the right in our sole discretion to edit or remove information or materials provided by you.</p>\
    <p style=\"margin-top:15px;\"><h3>Rules for Real Estate Professionals</h3></p>\
    <p><span style=\"text-decoration:underline;\">Information Provided by Real Estate Professionals:</span> If you are a real estate service provider, you agree that you will not claim or submit listings that do not belong to you. When you submit or claim a listing, you hereby agree to abide by the User Terms and Conditions signed by you.</p>\
    <p ><span style=\"text-decoration:underline;\">Studentacco.com User Content Provided to Real Estate Professionals:</span> If you are a real estate service provider, you agree that you will not use any information about Studentacco.com users that is transferred to you during your use of Studentacco.com's Website or Services (e.g., contact information sent to you when a user contacts you through your listing page) for any reason except to provide those users with real estate services. You further agree never to use such information for any illegal or harmful purpose.</p>\
    <p  style=\"margin-top:15px;\"><h3>Intellectual Property and Licenses</h3></p>\
    <p ><span style=\"text-decoration:underline;\">Studentacco.com Grants You a Limited License to Use Our Services:</span> Subject to these Terms of Use and any other policies we create, we grant you a limited right to access the Website, use our Services, and print materials for your personal, non-commercial, and informational use only. This license does not allow you to copy or sell our Services or Materials; scrape or mine our Website, Services, or Materials; or frame any part of our Website or Services. We reserve the right, without notice and in our sole discretion, to terminate your license to use the Website or Services, and to block or prevent future access to and use of the Website or Services.</p>\
    <p >Except for the limited license granted to you, you are not conveyed any other right or license in any way. Any unauthorized use of our Website or Services, and any use that exceeds the license granted to you, will terminate the permission or license granted by these Terms of Use.</p>\
    <p >You agree and understand that:</p>\
    <ul>\
    <li>The contents of the Website including but not limited to the information, logos, designs, databases, arrangement of databases, user interfaces, response formats, videos, testimonials, software, audio, pictures, icons, are the sole property of Studentacco.com or our licensors. All intellectual property in and to the Website and its contents and functionalities shall vest solely with Studentacco.com or our licensors.</li>\
    <li>Save for the limited right to access and use the Website in accordance with the Terms of Use and other applicable agreements, on a non-exclusive and non-transferable basis, there are no other rights being granted to you in the Website or any of its content and functionalities.</li>\
    <li>To the extent required, you grant Studentacco.com a non-exclusive, royalty free, worldwide, transferrable, sub-licensable right to host, display, demonstrate, publicly perform, use, reproduce, format, and distribute any materials, trademarks, trade names and other forms of your intellectual property which you have provided to Studentacco.com.</li>\
    <li>You have no right to make any copies of the whole or part of the Website or any of the content therein.</li>\
    <li>You have no rights to remove, modify (including removing any copyright notices or proprietary markings) any part of the Website save for any User Content that belongs to you.</li>\
    <li>You have no right to use any search mechanisms other than that provided on the Website and you will not use any web-crawler or any data harvesting tools to harvest data of any sort from the Website.</li>\
    </ul>\
    <p >If you are found to be in violation of this clause Studentacco.com reserves the right to terminate your access to the Website immediately.</p>\
    <p ><span style=\"text-decoration:underline;\">Our Materials Are Protected:</span> All materials in Studentacco.com's Website and Services, including our branding, trade dress, trade names, logos, design, text, search results, graphics, images, pictures, page headers, custom graphics, icons, scripts, sound files and other files, and the selection and arrangement and compilation of information thereof (collectively \"Materials\"), are proprietary property of Studentacco.com, our suppliers, our licensors, or users, and are protected by Indian and international intellectual property laws, including copyright and trademark laws. Our Materials cannot be copied, imitated, or used, in whole or in part, without our prior explicit written permission. You may not use any meta tags or any other \"hidden text\" utilizing \"Studentacco.com\" or any other name, trademark, or product name of Studentacco.com without our permission.</p>\
    <p ><span style=\"text-decoration:underline;\">Our Use of Third Parties' Marks Does Not Imply Endorsement:</span> All other trademarks, registered trademarks, product names, and logos appearing on our Website and Services are the property of their respective owners. Reference to any products, services, processes, or other information, by trade name, trademark, manufacturer, supplier, or otherwise does not constitute or imply endorsement, sponsorship or recommendation thereof by us.</p>\
    <p  style=\"margin-top:15px;\"><h3>Third-Party Links, Sites, and Services</h3></p>\
    <p >Our Website and Services may contain links to third-party websites, advertisements, services, special offers, or other events, activities, or content (collectively <span>\"Third-Party Materials\"</span>). These Third-Party Materials are not under the control of Studentacco.com. We are providing these links to you only as a convenience, and the inclusion of any link does not imply affiliation, endorsement, or adoption by us of the website or any information contained therein. Studentacco.com is not responsible or liable for your use of or access to any Third-Party Materials. Whenever you leave Studentacco.com's Website or Services be aware that your activity outside our Website or Services will not be governed by our Terms of Use or other agreements.</p>\
    <p  style=\"margin-top:15px;\"><h3>No Warranties</h3></p>\
    <p >THIS WEBSITE, THE MATERIALS, AND THE SERVICES ARE PROVIDED ON AN \"AS IS\" BASIS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. ALL USE OF STUDENTACCO.COM'S WEBSITE, MATERIALS, AND SERVICES IS AT YOUR SOLE RISK.</p>\
    <p >WE SPECIFICALLY DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, Non-Infringement and any warranties arising out of the course of dealing or usage of trade.</p>\
    <p >Studentacco.com takes no responsibility and assumes no liability for any User Content or other content, including links to web pages, that you or any other user or third party posts or transmits using our Website or Services. You understand and agree that you may be exposed to User Content that is inaccurate, objectionable and inappropriate for children or otherwise unsuited to your purpose.</p>\
    <p >Studentacco.com is not responsible in any way for, does not monitor, and does not endorse or guarantee anything about any third-party content (including advertisements, offers, and promotions) that may appear in our Website or Services.</p>\
    <p >Studentacco.com does not represent in any manner that:</p>\
    <ul>\
    <li>The information, data or contents of the Website are accurate;</li>\
    <li>The Website will be available at all times and will operate error free or that there will be uninterrupted access and service;</li>\
    <li>The integrity of the information on the Website or information you upload will be maintained;</li>\
    <li>We endorses any of the views of any of the users who may have posted content;</li>\
    <li>We have verified or guarantee the quality of services or representations made by any user of the Website;</li>\
    <li>We have verified the credit worthiness of any user;</li>\
    <li>We have screened or verified any of the information posted herein; and</li>\
    <li>The Website or any content is free from viruses or other malware.</li>\
    </ul>\
    <p >Any verification conducted by Studentacco.com shall be limited to the capture, by an employee or agent of Studentacco.com, of photographs of the property that is the subject matter of a listing. The photographs are then listed on the Website and are available for viewing by all persons who visit the specific pages associated with a verified listing. Please be aware that the photographs are specific to a particular time and that what you see in them may have subsequently been altered. We do not take any responsibility for the accuracy of the photographs or for keeping the photographs updated. The photographs are intended only as a preliminary visual guide to the wording of the listing and it shall be entirely your responsibility to visit, view and determine the suitability (for your needs) of any property listed on the Website prior to entering into any transaction with respect to the same.</p>\
    <p >The Website is only a platform for the advertising of opportunities for transactions that two users of the Website may enter into outside of the auspices of the Website or the Services provided by Studentacco.com. Any contractual or commercial agreements are agreed to between users alone and neither the Website nor Studentacco.com shall be in any manner liable or responsible for these commercial arrangements. Studentacco.com is not responsible for any breach of any contract concluded by any of the user(s).</p>\
    <p >Your use of the Website and its functionalities shall not act to make Studentacco.com your agent in any form or manner. Any disputes between you and any other user/s are to be resolved between you and such user(s) only and Studentacco.com is not responsible and shall not be required to mediate or resolve any disputes or disagreements between such users. You acknowledge and agree that you cannot and will not enjoin Studentacco.com or our affiliates, officers, employees, agents and professional advisors as a party to any such dispute.</p>\
    <p >You expressly release Studentacco.com, our affiliates, officers, employees, agents and professional advisors from any cost, damage, liability or other consequence of any of the actions of the users of the Website.</p>\
    <p  style=\"margin-top:15px;\"><h3>Indemnification</h3></p>\
    <p >You agree to defend, indemnify, and hold Studentacco.com harmless from and against any claims, damages, costs, liabilities, and expenses (including, but not limited to, reasonable attorneys' fees) arising out of or related to any User Content you post, store, or otherwise transmit on or through the Website or Services or your use of the Website and the Services, including, without limitation, any actual or threatened suit, demand, or claim made against Studentacco.com arising out of or relating to the User Content, your conduct, your violation of these Terms of Use, or your violation of the rights of any third party.</p>\
    <p  style=\"margin-top:15px;\"><h3>Limitation Of Liability</h3></p>\
    <p>IN NO EVENT SHALL STUDENTACCO.COM, OUR OFFICERS, DIRECTORS, AGENTS, AFFILIATES, EMPLOYEES, ADVERTISERS, OR DATA PROVIDERS BE LIABLE FOR ANY INDIRECT, SPECIAL, INCIDENTAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE, LOSS OF PROFITS, OR LOSS OF DATA) WHETHER IN AN ACTION IN CONTRACT, TORT (INCLUDING BUT NOT LIMITED TO NEGLIGENCE), EQUITY OR OTHERWISE, ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE USE OF THIS WEBSITE, THE MATERIALS, OR OUR SERVICES. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LIABILITY, SO THE ABOVE LIMITATIONS MAY NOT APPLY TO YOU.</p>                                                                                     <p >The aggregate liability of Studentacco.com to you or anyone, whether in contract, tort, negligence or otherwise, howsoever arising, whether in connection with these Terms of Use, your access and use of this Website and its contents and functionalities or for any reason related to the operation of the Website, shall not exceed INR 200 (Indian Rupees Two Hundred only). In no event shall Studentacco.com be liable for any loss of profits (anticipated or real), loss of business, loss of reputation, loss of data, loss of goodwill, any business interruption or any direct, indirect, special, incidental, consequential, punitive, tort or other damages, however caused, whether or not we have been advised of the possibility of such damages.</p>\
    <p  style=\"margin-top:15px;\"><h3>General Terms</h3></p>\
    <p ><span style=\"text-decoration:underline;\">Termination:</span> Studentacco.com reserves the right to terminate your access to the Website at any time, in our sole discretion. You acknowledge Studentacco.com’s right to do so and waive any claim that you may have arising from such termination. Notwithstanding the termination of access, all provisions, which by their nature are intended to survive, shall survive termination and continue to be applicable.</p>\
    <p ><span style=\"text-decoration:underline;\">Force Majeure:</span> In no event shall Studentacco.com be liable for any acts beyond our control or for any acts of god.</p>\
    <p ><span style=\"text-decoration:underline;\">Access:</span> Studentacco.com does not make any claim that the Website and its contents may be lawfully viewed or accessed in the jurisdiction you are viewing it in. You are solely responsible for complying with the laws applicable to you.</p>\
    <p ><span style=\"text-decoration:underline;\">Complaints:</span> Should you have any complaints regarding the Website, including but not limited to abuse and misuse of the Website, copyright infringement and the like, or any issues related to data privacy please report the same to info@studentacco.com.</p>\
    <p >Please provide your name, email address, physical address and contact numbers so that Studentacco.com may be in a position to verify details or check the authenticity of the complaints.</p>\
    <p ><span style=\"text-decoration:underline;\">Modification of Studentacco.com Services:</span> Studentacco.com reserves the right to modify or discontinue (completely or in part) our Website, Services, or any content appearing therein. Studentacco.com will not be liable to you or any third party if we exercise this right.</p>\
    <p ><span style=\"text-decoration:underline;\">Modification of These Terms:</span> We reserve the right to change or modify these Terms of Use, or any policy or guideline of the Website or Services, at any time and in our sole discretion. Any changes or modifications will be effective immediately upon posting of the revisions to the Website or Services. You waive any right you may have to receive specific notice of such changes or modifications. Your continued use of the Website or Services following the posting of changes or modifications will confirm your acceptance of such changes or modifications. Please review these terms and conditions periodically and check the version date for changes.</p>\
    <p ><span style=\"text-decoration:underline;\">Choice of Law:</span> These Terms of Use are governed by the laws of India. The courts in Noida, India shall have exclusive jurisdiction over any claim or matter arising out of these Terms of Use.</p>\
    <p ><span style=\"text-decoration:underline;\">No Waiver:</span> Studentacco.com's failure to exercise or enforce any right or provision of the Terms of Use will not be deemed to be a waiver of such right or provision.</p>\
    <p ><span style=\"text-decoration:underline;\">No Third-Party Beneficiaries or Rights:</span> These Terms of Use do not create any private right of action on the part of any third party or any reasonable expectation that the Website or Services will not contain any content that is prohibited by these Terms of Use.</p>\
    <p ><span style=\"text-decoration:underline;\">Entire Agreement and Severability:</span> These Terms of Use, the Privacy Policy and any amendments and additional agreements you might enter into with Studentacco.com in connection with our Website or Services, shall constitute the entire agreement between you and Studentacco.com concerning the Website or Services, and shall supersede any prior terms you had with Studentacco.com regarding the Website or Services.</p>\
    <p >If any provision of these Terms of Use is deemed invalid, then that provision will be limited or eliminated to the minimum extent necessary and the other provisions of these Terms of Use remain in full force and effect.</p>\
    <p ><span style=\"text-decoration:underline;\">Assignment:</span> You may not assign or otherwise transfer your rights or obligations under these Terms of Use. Studentacco.com may assign our rights and duties under these Terms without any such assignment being considered a change to the Term of Use and without any notice to you.</p>\
    <p ><span style=\"text-decoration:underline;\">Notices:</span> Any notices or other communications that you wish to send to Studentacco.com may be addressed to the registered office mentioned above.</p>\
    <p ><span style=\"text-decoration:underline;\">Dispute Resolution:</span> Unless you have entered into an additional agreement with Studentacco.com that provides for an alternative dispute resolution mechanism, you agree that any dispute arising between you and Studentacco.com which cannot be resolved amicably shall be conclusively resolved by a sole arbitrator. The Arbitration shall be conducted as per the Arbitration rules laid down under the Arbitration and Conciliation Act, 1996, and any modification/amendment effected thereafter from time to time. The arbitration shall be conducted in the English language and the award passed by the Arbitrator shall be final and binding on both parties. The cost of arbitration shall be borne by you, unless awarded otherwise.</p>\
    <p ><span style=\"text-decoration:underline;\">Contact Information:</span> If you have any questions or suggestions regarding our Terms of Use, please contact us at info@studentacco.com.</p>\
    </div></body></html>";
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [strTemp dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                        NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                            documentAttributes: nil
                                            error: nil
                                            ];
    termsConditionTextView.attributedText = attributedString;
    termsConditionTextView.editable = NO;
}

- (IBAction)googleLogin:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
    
}


- (IBAction)fbLoginButton:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [FBSDKAccessToken currentAccessToken];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100),first_name,last_name,email"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@", result);
                          
                          fName=[result valueForKey:@"first_name"];
                          lNmae=[result valueForKey:@"last_name"];;
                          emailId=[result valueForKey:@"email"];
                          NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                          NSURL *URL= [[NSURL alloc]initWithString:imageStringOfLoginUser];
                          imgURL = URL;
                          
                          
                          
                          
                          NSString *jsonRequest = [NSString stringWithFormat:@"{\"email\":\"%@\"}",emailId];
                          
                          NSLog(@"jsonRequest #### %@",jsonRequest);
                          NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,check_user_URL];
                          requestFor= check_user_URL;
                          URLConnection *connection=[[URLConnection alloc] init];
                          connection.delegate=self;
                          [connection getDataFromUrl:jsonRequest webService:urlString];
                          
                      }
                  }];
             }
             NSLog(@"Logged in");
         }
     }];
    
}





- (IBAction)showRightMenuPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)clickOnSignUp{
    
    [self.view endEditing:YES];
    if (userFirstName.length > 0 &&userLastName.length > 0 && userEmail.length > 0 && userMobile.length > 0 )
    {
        
                    if([self validateEmail:userEmail])
                        {
                            
                             if ([self validateMobieNumber:userMobile])
                            {
                                
                               if (isAgreeTermsCondition)
                                {
                               [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];

                NSString *jsonRequest = [NSString stringWithFormat:@"{\"userType\":\"%@\",\"firstname\":\"%@\",\"lastName\":\"%@\",\"email\":\"%@\",\"mobile_number\":\"%@\"}",userType, userFirstName, userLastName, userEmail, userMobile];
                
                                NSLog(@"%@",jsonRequest);
                NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,SignUp_URL];
                                requestFor=SignUp_URL;
                
                                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
                                    
                URLConnection *connection=[[URLConnection alloc] init];
                connection.delegate=self;
                [connection getDataFromUrl:jsonRequest webService:urlString];
            }
                               else{
                                   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Terms & Condition Required" preferredStyle:UIAlertControllerStyleAlert];
                                   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                       
                                   }];
                                   [alertController addAction:cancelAction];
                                   [self presentViewController:alertController animated:YES completion:nil];
                               }
                    }
                                
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mobile Number is not valid" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
            else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Email is not valid." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            
            }
        }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mandatory fields can not be empty." preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                                }];
                                [alertController addAction:cancelAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                }
    
    }
#pragma mark - UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = registrationFormList.count + 4;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = kCustomTextFieldTableViewCell;
   
    static NSString *cellIdentifier3 = kTermConditionTableViewCell;
    
    static NSString *cellIdentifier2 = kBlankTableViewCell;
    UITableViewCell *cell = nil;
    

    if (indexPath.row < registrationFormList.count){
        
        CustomTextFieldTableViewCell *textFieldCell= (CustomTextFieldTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        textFieldCell.userInputTextField.placeholder=registrationFormList[indexPath.row];
        textFieldCell.titleNameLabel.text = registrationFormList[indexPath.row];
        
        textFieldCell.userInputTextField.delegate = self;
        textFieldCell.userInputTextField.userInteractionEnabled = true;
        
        textFieldCell.astricLabel.hidden = YES;
        textFieldCell.dropDownImageView.hidden = YES;
        textFieldCell.userInputTextField.secureTextEntry=false;
        
        switch (indexPath.row) {
            case 0:
                    textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                    textFieldCell.userInputTextField.layer.borderWidth=0.8;
                textFieldCell.userInputTextField.text = userType;
                break;
            case 1:
                if(userSocialLoginData!=nil || userSocialLoginData!=NULL || userSocialLoginData!=Nil)
                {
                    
                     NSLog(@"Social Login Data is.....%@",userSocialLoginData);
                    userFirstName =[userSocialLoginData valueForKey:@"FBFirstName"] ;
                }
                  textFieldCell.userInputTextField.text = userFirstName;
                break;
            case 2:
                if(userSocialLoginData!=nil || userSocialLoginData!=NULL || userSocialLoginData!=Nil )
                {
                  userLastName = [userSocialLoginData valueForKey:@"FBLastName"] ;
                }
              
                textFieldCell.userInputTextField.text = userLastName;
                              break;
            case 3:
                textFieldCell.userInputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                if(userSocialLoginData!=nil || userSocialLoginData!=NULL || userSocialLoginData!=Nil)
                {
                   userEmail = [userSocialLoginData valueForKey:@"FBMailID"] ;
                }
               
                    textFieldCell.userInputTextField.text = userEmail;
                break;
            case 4:
                 textFieldCell.userInputTextField.keyboardType = UIKeyboardTypePhonePad;
                textFieldCell.userInputTextField.text = userMobile;
                break;
            default:
                break;
        }
        

        if(indexPath.row == 0){
            textFieldCell.dropDownImageView.hidden = NO;
            textFieldCell.userInputTextField.userInteractionEnabled = false;
        }
        
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4  ) {
            textFieldCell.astricLabel.hidden = NO;
        }
        cell = textFieldCell;
    }
    else if(indexPath.row==5) {
        TermConditionTableViewCell *textFieldCell= (TermConditionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        
       
        
        [textFieldCell.agreeButton addTarget:self action:@selector(checkAgreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (isAgreeTermsCondition) {
            [textFieldCell.agreeButton setImage:[UIImage imageNamed:@"checkbox-grey-checked.png"] forState:UIControlStateNormal];
        }
        else
        {
            [textFieldCell.agreeButton setImage:[UIImage imageNamed:@"checkbox-grey.png"] forState:UIControlStateNormal];
        }
        [textFieldCell.TermsConditionButton addTarget:self action:@selector(showTermCondition) forControlEvents:UIControlEventTouchUpInside];
        [textFieldCell.submitButton addTarget:self action:@selector(clickOnSignUp) forControlEvents:UIControlEventTouchUpInside];
        cell = textFieldCell;

    
         }
    else
    {
        BlankTableViewCell *textFieldCell = (BlankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell = textFieldCell;
        cell.userInteractionEnabled=NO;
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            pickerArray = [NSArray arrayWithArray:userTypeArray];
             [self bringUpPickerViewWithRow:indexPath];
            break;
//        case 4:
//            [self showTermCondition];
//            break;
           default:
            break;
    }
    
   
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
  
    return 0.0f;
}

#pragma mark connectionDelegates .. .. .. .. .. ..

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSError* error;
    NSMutableDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receiveData
                                           options:kNilOptions
                                             error:&error];
    NSLog(@"%@",json);
    if ([json[@"code"] integerValue] == 200) {
        if ([requestFor isEqualToString:SignUp_URL]){
            NSLog(@"%@",json);
            
            userdetails = json[@"user_details"];
            
            
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you for registering with Studentacco." message:@"Please verify your mobile number" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancelAction];
        
        UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"Submit"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               otp=alert.textFields.firstObject.text;
//                                                               otp=alert.textFields.lastObject.text;
                                                               NSLog(@"%@",otp);
                                                               [self verifyOtpNumber];
                                                               
                                                           }];
        
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"OTP Number";
            otp=textField.text;
            textField.text=[NSString stringWithFormat:@"%@",otp];
            }];
        [alert addAction:submitButton];
        
        [self presentViewController:alert animated:YES completion:nil];

        }
    else if ([requestFor isEqualToString:VerifySignUpOtp_URL])
    {
        userDetail = [[UserDetail alloc]init];
        userDetail.userid = userdetails[@"userid"];
        userDetail.usertype = userdetails[@"userType"];
        //userDetail.username = userdetails[@"username"];
        userDetail.firstname = userdetails[@"firstname"];
        userDetail.lastname = userdetails[@"lastName"];
        userDetail.email = userdetails[@"email"];
        userDetail.gender = userdetails[@"gender"];
        userDetail.mobile = userdetails[@"mobile_number"];
        userDetail.addressline1 = userdetails[@"addressline1"];
        userDetail.addressline2 = userdetails[@"addressline2"];
        userDetail.city = userdetails[@"city"];
        userDetail.state = userdetails[@"state"];
        userDetail.country = userdetails[@"country"];
        userDetail.pin = userdetails[@"pin"];
        userDetail.profile_picture = userdetails[@"profile_picture"];
        
        NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
        [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:SideMenuUpdateNotification
                                                           object:nil];
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
        //NSString *alert=json[@"message"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thanks" message:@"Your mobile number verified successfully" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self callViewController];            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
       
    }
    else if ([requestFor isEqualToString:check_user_URL]){
        //{[json[@"code"] integerValue] == 200)
        userDetail = [[UserDetail alloc]init];
        userDetail.firstname=fName;
        userDetail.lastname=lNmae;
        userDetail.email=emailId;
        userDetail.profile_picture=imgURL;
        NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
        [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
        SignupViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
        [self.navigationController pushViewController:obj animated:YES];
        
    }

    
    }
    else if (([json[@"code"] integerValue] == 201) )

    {
        if ([requestFor isEqualToString:SignUp_URL]) {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
            // NSString *alert=json[@"message"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"User already exist" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        else if ([requestFor isEqualToString:check_user_URL]){
            userDetail = [[UserDetail alloc]init];
            NSDictionary *dic=[json valueForKey:@"user_details"];
            userDetail.firstname=fName;
            userDetail.lastname=lNmae;
            userDetail.email=emailId;
            userDetail.userid=[dic valueForKey:@"userID"];
            userDetail.profile_picture=imgURL;
            NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
            [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
            [[NSNotificationCenter defaultCenter]postNotificationName:SideMenuUpdateNotification
                                                               object:nil];
        }
        
        else if ([requestFor isEqualToString:VerifySignUpOtp_URL])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Not entered valid otp" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    
}

-(void)callViewController
{
    NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
    [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
    [[NSNotificationCenter defaultCenter]postNotificationName:SideMenuUpdateNotification
                                                       object:nil];
    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self .navigationController pushViewController:obj animated:YES];
    
}


-(void)verifyOtpNumber
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"otp\":\"%@\"}",otp];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,VerifySignUpOtp_URL];
    requestFor=VerifySignUpOtp_URL;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
}



- (void)connectionFailWithError:(NSError *)error
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)takePhotoFromCamera {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

-(void)chooseImageClicked:(UIButton*)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoGalleryButton = [UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        [self presentViewController:picker animated:YES completion:NULL];
        
    }];
    UIAlertAction *cameraButton = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoFromCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:cameraButton];
    [actionSheet addAction:photoGalleryButton];
    [actionSheet addAction:cancelAction];
    
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}
-(void)checkAgreeButtonClicked:(UIButton*)sender
{
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [registrationTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    //[sender setBackgroundImage:[UIImage imageNamed:@"checkbox-grey.png"] forState:UIControlStateSelected];
    if (isAgreeTermsCondition) {
        isAgreeTermsCondition=NO;
    }
    else
    {
        isAgreeTermsCondition=YES;
        
    }
    [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}




//-(void)selectGender:(UIButton*)sender
//{
//    [self.view endEditing:YES];
//    
//    NSIndexPath *indexPath = [registrationTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
//    [sender setBackgroundImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateSelected];
//    if ([sender tag] == 100) {
//        [sender setBackgroundImage:[UIImage imageNamed:@"radio-button-checked.png"] forState:UIControlStateSelected];
//        
//     
//        userGender=@"Male";
//    }
//   else if([sender tag] == 101)
//   {
//      [sender setBackgroundImage:[UIImage imageNamed:@"radio-button-checked.png"] forState:UIControlStateSelected];
//        userGender=@"Female";
//    }
//    else
//    {
//        userGender=@" ";
//        [sender setBackgroundImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateSelected];
//    }
//     [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}
//
//-(void)checkAgreeButtonClicked:(UIButton*)sender
//{
//    [self.view endEditing:YES];
//    NSIndexPath *indexPath = [registrationTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
//    //[sender setBackgroundImage:[UIImage imageNamed:@"checkbox-grey.png"] forState:UIControlStateSelected];
//    if (isAgreeTermsCondition) {
//        isAgreeTermsCondition=NO;
//    }
//    else
//    {
//        isAgreeTermsCondition=YES;
//       
//    }
//    [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}
//

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageTempData = UIImagePNGRepresentation(chosenImage);
    imageData = [NSString stringWithFormat:@"%@",imageTempData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissModalViewControllerAnimated:YES];
//    imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePickerView];
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:registrationTableView];
    
    NSIndexPath * indexPath = [registrationTableView indexPathForRowAtPoint:point];
    
    [registrationTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
//    CustomTextFieldTableViewCell *textFieldRowCell = (CustomTextFieldTableViewCell *) textField.superview.superview;
//    NSIndexPath *indexPath = [registrationTableView indexPathForCell:textFieldRowCell];
//
//    switch (indexPath.row) {
//        case 1:
//            userFirstName = textField.text;
//            break;
//        case 2:
//            userLastName = textField.text;
//            break;
//        case 3:
//            userMobile = textField.text;
//            break;
//        case 4:
//            userEmail = textField.text;
//            break;
//        case 5:
//            userPassword = textField.text;
//            break;
//        case 6:
//            userConfirmPassword = textField.text;
//            break;
//        case 13:
//            addressline1 = textField.text;
//            break;
//        case 14:
//            addressline2 = textField.text;
//            break;
//        case 15:
//            userPincode = textField.text;
//            break;
//        default:
//            break;
//    }
    return true;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CustomTextFieldTableViewCell *textFieldRowCell = (CustomTextFieldTableViewCell *) textField.superview.superview;
    NSIndexPath *indexPath = [registrationTableView indexPathForCell:textFieldRowCell];
    
    switch (indexPath.row) {
        case 1:
            userFirstName = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 2:
            userLastName = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 3:
          userEmail = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 4:
            
            userMobile = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        default:
            break;
    }

    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UIPickerView Delegate

- (void)bringUpPickerViewWithRow:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    selectedIndexPath = indexPath;
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         pickerView.hidden = NO;
                         pickerView.frame=CGRectMake(0, self.view.bounds.size.height-180, self.view.bounds.size.width, 222);
                         [pickerView reloadAllComponents];
                         
                     } completion:nil];
}

- (void)hidePickerView
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         pickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
                         
                     } completion:^(BOOL finished) {
                         
                         pickerView.hidden = YES;
                     }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self hidePickerView];
    NSLog(@"row selected:%ld", (long)row);
    switch (selectedIndexPath.row) {
        case 0:
            userType = pickerArray[row];
            break;
        default:
            break;
    }
    [registrationTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];

}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerArray[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

#pragma mark - Date Picker

- (void)bringDatePickerView:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    selectedIndexPath = indexPath;
    
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];

    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height-180, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
}


- (IBAction)doneSelected:(id)sender {
    
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd-MM-yyyy"];
    dob=[outputFormatter stringFromDate:datePicker.date];
    
    [registrationTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)cancelSelected:(id)sender
{
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL) validateMobieNumber:(NSString *) stringToBeTested {
    NSLog(@"%@",userMobile);
    
    
    NSString *mobileNumberRegex = @"[789][0-9]{9}";
    NSPredicate *mobileNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegex];
    
    return [mobileNumberTest evaluateWithObject:stringToBeTested];
}
- (IBAction)backToPreviousView:(id)sender {
    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self .navigationController pushViewController:obj animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
