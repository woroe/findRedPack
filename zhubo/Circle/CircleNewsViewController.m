//
//  ZhuBoEditViewController.m
//  zhubo
//
//  Created by Jin on 2017/6/13.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "CircleNewsViewController.h"
#import "MyTableViewCell.h"

#import "OSSImageUploader.h"

@interface CircleNewsViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *photosBack;
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, assign) CGFloat collctionCellW;
@property (nonatomic, strong) NSMutableArray *choiceImages;


@property (nonatomic, strong) NSString *locationAddr;
@property (nonatomic, assign) BOOL isOpen;


@end

static NSString *placeHolder = @"说点什么";
static NSString *tabcellId = @"MyTableViewCellID";
static NSString *collcellId = @"collectionViewID";

@implementation CircleNewsViewController

@synthesize model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"ZhuBoEditViewController" owner:nil options:nil] lastObject];
    
    UIBarButtonItem *ite =[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = ite;
    
    self.choiceImages = [NSMutableArray array];
    [self loadUI];
    
    
}

- (void)loadUI {
    
    self.textView.text = placeHolder;
    self.textView.textColor = [UIColor grayColor];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:15.f];
    self.textView.clearsContextBeforeDrawing = NO;
    self.textView.autocorrectionType = UITextAutocorrectionTypeYes;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    [topView setItems:buttonsArray];
    [self.textView setInputAccessoryView:topView];
    
    
    self.locationAddr = @"位置";
    self.isOpen = YES;
    
    //collectionView
    self.collctionCellW = (SCREEN_WIDTH - 90 * SCREEN_W_SCALE ) / 4;
    CGRect collFrame = CGRectMake(MARGIN_30, self.textView.frame.size.height, self.photosBack.frame.size.width - 60 * SCREEN_W_SCALE, self.collctionCellW);
    _customLayout = [[UICollectionViewFlowLayout alloc] init];
    // 自定义的布局对象
    _customLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _customLayout.itemSize = CGSizeMake(_collctionCellW, _collctionCellW);
    _customLayout.minimumLineSpacing = 10 * SCREEN_W_SCALE;
    _customLayout.minimumInteritemSpacing = 10 * SCREEN_W_SCALE;
    _collectionView = [[UICollectionView alloc] initWithFrame:collFrame collectionViewLayout:_customLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collcellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.photosBack addSubview:self.collectionView];
    
    //重新设置frame
    [self resetViewFrame];
    
    //tableView
    //    [self.tabView registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:tabcellId];
    //    self.tabView.dataSource = self;
    //    self.tabView.delegate = self;
    //    self.tabView.allowsSelection = NO;
    
}

#pragma mark --发布动态
-(void)rightBtnClick{
    NSArray *arr = [NSArray arrayWithArray:_choiceImages];
    [OSSImageUploader asyncUploadImages:arr complete:^(NSArray<NSString *> *names, UploadImageState state) {
        
        NSMutableString *mtStr = [NSMutableString new];
        for (NSString *str in names) {
            NSString *str111= [NSString stringWithFormat:@"http://zhuboapp.oss-cn-shanghai.aliyuncs.com/%@",str];
            if (mtStr.length == 0) {
                mtStr = [NSMutableString stringWithFormat:@"%@",str111];
            }else{
                mtStr = [NSMutableString stringWithFormat:@"%@@%@",mtStr,str111];
            }
        }
        NSLog(@"names---%@", names);
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"BuildSowingType"] = @"BuildSowing_ReleaseCircleNews";
        params[@"UserId"] = @([BaseData shareInstance].userId);
        params[@"CircleId"] = @(model.circleId);
        params[@"Words"] = self.textView.text;
        params[@"NewsContent"] = mtStr;
        params[@"NewsContentType"] = @"1";
        
        
        [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *res = (NSDictionary *)responseObject;
            ZBLog(@"BuildSowing_ReleaseCircleNews--%@", res);
            if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
                [SVProgressHUD showSuccessWithStatus:@""];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [SVProgressHUD showErrorWithStatus:BaseStringNetError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }];
        
    }];
}

#pragma mark --关闭键盘
-(void) dismissKeyBoard{
    [self.textView resignFirstResponder];
}

- (void)resetViewFrame {
    
    NSInteger lines = (NSInteger)ceil( (self.choiceImages.count + 1) / 4.0 );
    NSInteger linesIndex = (self.choiceImages.count + 1) % 4;
    CGRect collFrame = self.collectionView.frame;
    //增加行、减少行
    if(lines > 1 && ( linesIndex == 1 || linesIndex == 0)){
        collFrame.size.height = self.collctionCellW * lines + (lines - 1) * 10 * SCREEN_W_SCALE;
        self.collectionView.frame = collFrame;
        
        CGRect tabFrame = self.tabView.frame;
        tabFrame.origin.y = collFrame.size.height + collFrame.origin.y + 15 *SCREEN_W_SCALE;
        self.tabView.frame = tabFrame;
    }
    
    CGRect photoBCFrame = self.photosBack.frame;
    photoBCFrame.size.height = collFrame.size.height + collFrame.origin.y;
    self.photosBack.frame = photoBCFrame;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.choiceImages.count + 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self resetViewFrame];
    
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:collcellId forIndexPath:indexPath];
    
    if(indexPath.row == self.choiceImages.count) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.collctionCellW, self.collctionCellW)];
        [btn setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(choiceImage:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    else {
        //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.choiceImages[indexPath.row]]];
        UIImage *image = self.choiceImages[indexPath.row];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.collctionCellW, self.collctionCellW)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.layer.masksToBounds = YES;
        imgView.userInteractionEnabled = YES;
        imgView.image = image;
        [cell addSubview:imgView];
    }
    
    return cell;
}


#pragma mark - choiceImage
- (void)choiceImage:(id)sender {
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = self.photoType;
    pickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    ZBLog(@"---info:%@", info);
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqual: (NSString *)kUTTypeImage]) {
        [self.choiceImages addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [self.collectionView reloadData];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = placeHolder;
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeHolder]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tabcellId forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell setImage:@"dingweiz" WithTitle:self.locationAddr];
    }
    else{
        NSString *str = self.isOpen ? @"公开" : @"不公开";
        [cell setImage:@"gongkai" WithTitle:str];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
