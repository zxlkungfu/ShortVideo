//
//  VideoViewController.m
//  ShortVideo
//
//  Created by 郑小龙 on 2017/5/25.
//  Copyright © 2017年 alon. All rights reserved.
//

#import "VideoViewController.h"
//#import "VideoTableViewCell.h"
#import "VideoModel.h"
#import "CommentModel.h"
#import "VideoCollectionViewCell.h"
#import "UploadVideoViewController.h"

#import "PlayVideoViewController.h"
#import "UserModel.h"


#define KVideoUrlPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

//static NSString *videoTableCellIdentifier = @"videoTableCellIdentifier";
static NSString *videoCollectionCellIdentifier = @"videoCollectionCellIdentifier";


@interface VideoViewController ()</*UITableViewDataSource, UITableViewDelegate, */UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
//    UITableView *_tableView;
    UICollectionView *_collectionView;
    NSMutableArray<VideoModel *> *_dataArray;
    NSArray<CommentModel *> *_commentArray;
    UICollectionViewFlowLayout *_layout;
    UIButton *_changeButton;
    UIButton *_uploadButton;
}

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _changeButton.hidden = NO;
    _uploadButton.hidden = NO;
    [self request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _changeButton.hidden = YES;
    _uploadButton.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGFloat width = Screen_Width - 2 * Column_Spacing;
    [self layoutWithItemWidth:width];
    
    [self createCollectionView];
    
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setImage:[UIImage imageNamed:@"changeView.png"] forState:UIControlStateNormal];
    changeButton.titleLabel.textColor = [UIColor whiteColor];
    changeButton.frame = CGRectMake(Screen_Width-50, 5, 34, 34);
    [changeButton addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:changeButton];
    _changeButton = changeButton;
    
    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [uploadButton setImage:[UIImage imageNamed:@"uploadVideo.png"] forState:UIControlStateNormal];
    uploadButton.titleLabel.textColor = [UIColor whiteColor];
    uploadButton.frame = CGRectMake(10, 5, 34, 34);
    [uploadButton addTarget:self action:@selector(uploadVideoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:uploadButton];
    _uploadButton = uploadButton;
    
    
  /*
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [_tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:videoCellIdentifier];
//    [self.view addSubview:_tableView];
//    _tableView.rowHeight = UITableViewAutomaticDimension;
//    _tableView.estimatedRowHeight = 44;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = [UIColor bkColor];
//    _tableView.tableFooterView = [[UIView alloc] init];
//    
//    
//    [Request listVideoWithURL:@"listVideo.php" parameters:nil andSuccessBlock:^(BOOL success, id data) {
//        if (success) {
//            
//            NSError *error;
//            NSArray *videoArray = [data objectForKey:@"data"];
//            _dataArray = [NSMutableArray array];
//            for (NSDictionary *dict in videoArray) {
//                VideoModel *model = [[VideoModel alloc] initWithDictionary:dict error:&error];
//                [_dataArray addObject:model];
////                NSLog(@"%@", model);
//            }
//            [_tableView reloadData];
//            
//        } else {
//            NSLog(@"data=%@", data);
//        }
//    } andFailureBolck:^(NSError *error) {
//        
//    }];
//    
   */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadVideoClick {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie/*,(NSString *)kUTTypeVideo*/, nil];
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:NO completion:nil];
    }
    
}



/*
-(void)cleanCachesVideo{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
        [fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:KVideoUrlPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [fileManager removeItemAtPath:[KVideoUrlPath stringByAppendingPathComponent:filename] error:NULL];
    }
}
*/


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *sourceURL = (NSURL *)[info objectForKey:UIImagePickerControllerMediaURL];
        NSString *sourcePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        UploadVideoViewController *vc = [[UploadVideoViewController alloc] init];
        
        if (sourcePath.length) {
            vc.videoPath = sourcePath;
            vc.videoSource = sourceURL;
            [picker dismissViewControllerAnimated:NO completion:^{
                [self.navigationController pushViewController:vc animated:YES];
            }];
            return;
        } else {
           
            [picker dismissViewControllerAnimated:NO completion:nil];
            return;
        }
        
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)changeView:(UIButton *)sender {
    sender.enabled = NO;
    CGFloat width = _layout.itemSize.width == (Screen_Width - 2 * Column_Spacing) ? (Screen_Width-(3 * Column_Spacing)) / 2.0 : (Screen_Width - 2 * Column_Spacing);
    
    [self layoutWithItemWidth:width];
    _collectionView.collectionViewLayout = _layout;
//    [self createCollectionView];
    [_collectionView reloadData];
    sender.enabled = YES;
    
   
}

- (void)layoutWithItemWidth:(CGFloat)width {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat height = width / 16 * 9.0;
    layout.itemSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = Column_Spacing; // 行间距
    layout.minimumInteritemSpacing = Column_Spacing;
    layout.sectionInset = UIEdgeInsetsMake(Column_Spacing, Column_Spacing, Column_Spacing, Column_Spacing);
    _layout = layout;
}

- (void)createCollectionView {
    [_collectionView removeFromSuperview];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
        dispatch_time_t dely = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(dely, dispatch_get_main_queue(), ^{
             [_collectionView.mj_header endRefreshing];
        });
    }];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; // 解决点击切换按钮时，集合视图在导航栏下面显示
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:videoCollectionCellIdentifier];
}

- (void)request {
    [Request listVideoWithURL:@"listVideo.php" parameters:nil andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            
            NSError *error;
            NSArray *videoArray = [data objectForKey:@"data"];
            _dataArray = [NSMutableArray array];
            for (NSDictionary *dict in videoArray) {
                VideoModel *model = [[VideoModel alloc] initWithDictionary:dict error:&error];
                if(!error) {
                    [_dataArray addObject:model];
                }
            }
            [_collectionView reloadData];
        } else {
            NSLog(@"data=%@", data);
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 100;
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
    return _dataArray.count ? 1 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:videoCollectionCellIdentifier forIndexPath:indexPath];
//    cell.videoTitle.text = _dataArray[indexPath.item].title;
//    cell.videoTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    VideoModel *model = _dataArray[indexPath.item];
    [cell setValueWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayVideoViewController *vc = [[PlayVideoViewController alloc] init];
    VideoModel *model = _dataArray[indexPath.item];
//    _commentArray = [NSArray arrayWithArray:model.comment];
//    vc.commentArray = [NSMutableArray arrayWithArray:_commentArray];
    vc.videoPath = model.url;
    vc.imagePath = model.imgURL;
    vc.videoTitle = model.title;
    [Request getInfoWithURL:@"getInfo.php" parameters:@{@"username":model.username} andSuccessBlock:^(BOOL success, id data) {
        if (success) {
            NSError *error;
            NSDictionary *dict = [data objectForKey:@"data"];
            UserModel *owner = [[UserModel alloc] initWithDictionary: dict error: &error];
            if (!error) {
                vc.model = owner;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } andFailureBolck:^(NSError *error) {
        
    }];
    
 
}

/*

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoTableCellIdentifier forIndexPath:indexPath];
    [cell setValueWithModel:_dataArray[indexPath.row]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentView.backgroundColor = [UIColor bkColor];
    
//    cell.topSeparate.backgroundColor = [UIColor separateColor];
    if (indexPath.row < _dataArray.count - 1) {
        cell.bottomSeparate.backgroundColor = [UIColor separateColor];
    } else {
        cell.bottomSeparate.backgroundColor = [UIColor bkColor];
    }
    return cell;
}
*/
 
@end
