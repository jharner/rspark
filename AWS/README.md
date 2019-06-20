## Running Rspark on AWS  ##
DISCLAIMER: 
Amazon Web Services (AWS) allows users the ability to, among other services, create virtual machines in the AWS cloud.  Using AWS services will cost the user a rate based upon computing power and reservation duration.  In order to use RSpark with AWS, you will need to be prepared to pay for the cloud services you utilize.

Prerequisites:  

	-	Amazon Web Services Account  
	-	Modern Browser (Chrome, Edge, Firefox, or Safari)  

1. Navigate to [Amazon Web Servces](https://aws.amazon.com/)

2. Log into your account by clicking the `My Account` dropdown at the top-right of the page and selecting the `AWS Management Console` option or click on the `Sign in to the Console` button. If you do not have an AWS account, click the "Create account" button at the top-right of the page.

![Step 1](https://github.com/jharner/rspark/blob/master/AWS/image1.jpg)


3. Once logged in, click the `All Services` dropdown and select `EC2` from the section titled `Compute`.

![Step 2](https://github.com/jharner/rspark/blob/master/AWS/image13.jpg)


4. Click `Instances` located in the left sidebar under the `Instances` header.

![Step 2](https://github.com/jharner/rspark/blob/master/AWS/image2.jpg)

5. Ensure that have the `N. Virginia` region selected in the top-right toolbar and click the blue 'Launch Instance' button.

![Step 3](https://github.com/jharner/rspark/blob/master/AWS/image3.jpg)
![Step 4](https://github.com/jharner/rspark/blob/master/AWS/image4.jpg)


6. On the left sidebar, click `Community AMIs`.

 ![Step 5](https://github.com/jharner/rspark/blob/master/AWS/image5.jpg)


7. Enter `rsparkbox` (without quotes) into the search bar labeled `Search community AMIs`. You will see two AMIs: `rsparkbox` and `rsparkbox3`. 

 ![Step 6](https://github.com/jharner/rspark/blob/master/AWS/image6.jpg)


8. Click the blue 'Select' button beside `rsparkbox3` (compatible with the current 0.9.4 version of `rspark`) to choose the rspark image. Note: `rsparkbox` is compatible with the older 0.9.2 version of `rspark`.

 ![Step 7](https://github.com/jharner/rspark/blob/master/AWS/image7.jpg)


9. Next, we choose the computing power we want our EC2 instance to have.  Select `t2.medium`.

 ![Step 8](https://github.com/jharner/rspark/blob/master/AWS/image8.jpg)


10. At the top of of the screen, just below the navbar, click `6. Configure Security Group`.

![Step 10](https://github.com/jharner/rspark/blob/master/AWS/image14.jpg)


11. Ensure that `Create a new security group` is selected. Then, in the bottom left corner click the dropdown labelled `ssh` and select `Custom TCP Rule`, which is the first item.

 ![Step 13](https://github.com/jharner/rspark/blob/master/AWS/image15.jpg)

12. Change the options for this rule.  

		- Enter `8787` for the Port Range.  
		- Select `Anywhere` under the `Source` column dropdown.  

NOTE: If you receieve any warning messages regarding SSH, disregard them, as we will not be connecting to our instance through `ssh`.

13. Click `Review and Launch` in the bottom right. After reviewing the next page, click `Launch` in the bottom right.

14. In the resulting popup, select `proceed without a key pair` from the dropdown.  Select the box labeled `I acknowledge...` and click `Launch Instance` in the bottom right.
	
 ![Step 17](https://github.com/jharner/rspark/blob/master/AWS/image9.jpg)


15. On the next page, click `View Instances` on the very bottom right of the page.

 ![Step 18](https://github.com/jharner/rspark/blob/master/AWS/image16.jpg)
 
If you have multiple instances, make sure you select the most recently created instance and deselect previously terminated instances. Wait until the `Instate Stete` is `Running` and the `Status Checks` are `2/2 checks` before proceeding to Step 16.``


16. On the instances screen, click on your newly created instance and copy down the IP address listed for your instance under the `IPv4 Public IP`, which can be found on the lower half of the screen.

![Step 19](https://github.com/jharner/rspark/blob/master/AWS/image18.jpg)

You may now connect to your Rspark server through a web browser:

17. Into a browser's URL bar, enter `http://0.0.0.0:8787` replacing `0.0.0.0` with the IP address of your instance copied from step 16

18. Log into Rstudio with the credentials:  

		username: rstudio  
		password: rstudiojh  
		
Note: `rspark-tutorial` is included in the instance of RStudio Server when it is launched. However, it will usually be slightly out of date and you may want to upload a new version from `jharner/rspark-tutorial` from `github.com` by downloading a zipped version.


## Shutting Down ##

You have two primary options when shutting down an AWS instance of RSpark. The difference between the two options is determined by your need to preserve the workspace. 

#### Preserve RSpark Workspace ####
In order to preserve your workspace and leave your files on the instance itself:  

1. Return to the [AWS instance screen](https://console.aws.amazon.com/ec2)  
2. Ensure your rspark instance is selected  
3. Click `Actions`  
4. Click `Instance State`  
5. Select `Stop`  

This will suspend your instance, rather than terminate it.  You will be charged a small amount per hour that your instance remains suspended (typically fractions of a cent per day.)

Next time you are ready to work again:

1. Return to the [AWS instance screen](https://console.aws.amazon.com/ec2)  
2. Ensure your rspark instance is selected  
3. Click `Actions`  
4. Click `Instance State`  
5. Select `Start`  

The IP address of your instance will have changed after being restarted. Repeat step 17 from the guide above to connect to your instance using this new IP address.

#### Dispose of Workspace ####

If you instead do not need to preserve the state and workspace of your Rspark instance, be sure to fully terminate the instance when you are finished with the following steps:

_IMPORTANT: Be sure to download all important files to your local computer and follow these steps to suspend the machine so that you are not charged for server runtime while it is not actively being used.  

1. Return to your [personal AWS Instances Dashboard](https://console.aws.amazon.com/ec2)  
2. Select your running Rspark instance.  
3. Once your instance is selected, click `Action` above the Instances list.  

![Step 19](https://github.com/jharner/rspark/blob/master/AWS/image17.jpg)

4. Next click `Instance State` from the dropdown and then click `Terminate`.

If you terminate an instance, you must start over at step 1 to create a totally new instance.


