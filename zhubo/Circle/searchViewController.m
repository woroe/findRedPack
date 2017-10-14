//
//  searchViewController.m
//  zhubo
//
//  Created by Jin on 2017/7/17.
//  Copyright © 2017年 重庆步联科技. All rights reserved.
//

#import "searchViewController.h"
#import "CircleDetailViewController.h"
#import "searchViewControllerCell.h"



@interface searchViewController ()

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UITableView *tabView;

@property(nonatomic, strong) NSMutableArray *models;

@end

@implementation searchViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _models = [NSMutableArray new];
    
    UIView *view11 = [self.view viewWithTag:121];
    UILabel *lal = [[UILabel alloc]initWithFrame:CGRectMake(23, 30, self.view.bounds.size.width - 96, 28)];
    lal.backgroundColor = [UIColor whiteColor];
    lal.layer.masksToBounds = YES;
    lal.layer.cornerRadius = 5;
    [view11 addSubview:lal];
    CGRect searchFrame = CGRectMake(15, 30, self.view.bounds.size.width - 80, 28);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:searchFrame];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [searchBar becomeFirstResponder];
    searchBar.placeholder = @"搜索圈子";
    searchBar.delegate = self;
    _searchBar = searchBar;
    [view11 addSubview:searchBar];
    
    UIButton *but = [view11 viewWithTag:112];
    [but addTarget:self action:@selector(quxiao:) forControlEvents:UIControlEventTouchDown];
    
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70)];
    [tabView registerNib:[UINib nibWithNibName:@"searchViewControllerCell" bundle:nil] forCellReuseIdentifier:@"searchViewControllerCellID"];
    tabView.delegate = self;
    tabView.dataSource = self;
    self.tabView = tabView;
    [self.view addSubview:tabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)quxiao:(UIButton *)sender{
    [self dismissViewController];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewController];
}
- (void)dismissViewController {
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark -- UISearchBarDelegate
//cancel按钮点击时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchData: _searchBar.text];
//    [self dismissViewController];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self searchData: searchText];
}

- (void)searchData:(NSString *)keyWords {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"BuildSowingType"] = @"BuildSowing_SelectCircle";
    params[@"Name"] = keyWords;
    
    [[AFHTTPSessionManager manager] POST:httpurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *res = (NSDictionary *)responseObject;
        if([[res objectForKey:@"StatusCode"] isEqual:@(1)]){
            ZBLog(@"BuildSowing_SelectCircle--%@", res);
            
            NSArray *dataArr = [res objectForKey:@"data"];
            if(!dataArr || dataArr.count == 0) {
                return ;
            }
            [self.models removeAllObjects];
            for (NSDictionary *data in dataArr) {
                CircleModel *model = [[CircleModel alloc] initWithDictionary:data];
                [self.models addObject:model];
            }
            [self.tabView reloadData];
        }
        else{
            [SVProgressHUD showErrorWithStatus:BaseStringNetError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:BaseStringNetError];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     searchViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchViewControllerCellID" forIndexPath:indexPath];
    
    CircleModel *model = _models[indexPath.row];
    UIImageView *imageVIew = [cell viewWithTag:10];
    [imageVIew sd_setImageWithURL:[NSURL URLWithString:model.headImg]];
    imageVIew.contentMode = UIViewContentModeScaleAspectFill;
    imageVIew.layer.masksToBounds = YES;
    imageVIew.layer.cornerRadius = imageVIew.frame.size.width/2;
    
    UILabel *manLal = [cell viewWithTag:11];
    manLal.text =model.name;
    
    UILabel *renshuLal = [cell viewWithTag:12];
    renshuLal.text = [NSString stringWithFormat:@"%ld人",model.peopleCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate FbNewsCircle:self.models[indexPath.row]];
    [self dismissViewController];
}


@end
