//
//  ViewController.m
//  GoogleAnimation
//

#import "ViewController.h"
#import "AnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AnimationView *v = [[AnimationView alloc] initWithFrame:self.view.bounds];
    v.backgroundColor = [UIColor grayColor];
    v.radius = 50;
    v.colors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor blueColor]];
    [self.view addSubview:v];
    
    [v beginAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
