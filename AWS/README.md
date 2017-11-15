## Running Rspark on AWS  ##
DISCLAIMER: 
Amazon Web Services (AWS) allows users the ability to, among other services, create virtual machines in the AWS cloud.  Using AWS services will cost the user a rate based upon computing power and reservation duration.  In order to use Rspark with AWS, you will need to be prepared to pay for the cloud services you utilize.

Prerequisites:
	-	 Amazon Web Services Account
	-  Modern Browser (Edge, Chrome, or Firefox)

1. Navigate to [Amazon Web Servces](https://aws.amazon.com/)

2. Log into your account by clicking the 'My Account' dropdown at the top-right of the page and selecting the 'AWS Management Console' option. If you do not have an AWS account, click the "Create account" button at the top-right of the page.

![Step 1](https://github.com/jharner/rspark/blob/master/AWS/image1.jpg)


3. Once logged in, click the 'All Services' dropdown and select 'EC2' from the section titled 'Compute'.

![Step 2](https://github.com/jharner/rspark/blob/master/AWS/image13.jpg)


4. Click 'Instances' located in the left sidebar under the 'Instances' header.

![Step 2](https://github.com/jharner/rspark/blob/master/AWS/image2.jpg)

5. Ensure that have the 'N. Virginia' region selected in the top-right toolbar and click the blue 'Launch Instance' button.

![Step 3](https://github.com/jharner/rspark/blob/master/AWS/image3.jpg)
![Step 4](https://github.com/jharner/rspark/blob/master/AWS/image4.jpg)


6. On the left sidebar, click 'Community AMIs'.

 ![Step 5](https://github.com/jharner/rspark/blob/master/AWS/image5.jpg)


7. Enter 'rsparkbox' (without quotes) into the search bar labeled 'Search community AMIs'.

 ![Step 6](https://github.com/jharner/rspark/blob/master/AWS/image6.jpg)


8. Click the blue 'Select' button to choose the rspark image.

 ![Step 7](https://github.com/jharner/rspark/blob/master/AWS/image7.jpg)


9. Next, we choose the computing power we want our EC2 instance to have.  Select 't2.medium'.

 ![Step 8](https://github.com/jharner/rspark/blob/master/AWS/image8.jpg)



10. At the top of of the screen, just below the dark blue navbar, click '6. Configure Security Group'.

![Step 10](https://github.com/jharner/rspark/blob/master/AWS/image14.jpg)


11. Ensure that 'Create a new security group' is selected. Then, in the bottom left corner click the dropdown labelled 'ssh' and select 'custom TCP'

 ![Step 13](https://github.com/jharner/rspark/blob/master/AWS/image15.jpg)

12. Change the options for this rule.
		- Enter '8787' for the Port Range. 
		- Select 'Anywhere' under the 'Source' column dropdown.
		- Click the blue 'Save' button on the bottom right.

13. Click 'Review and Launch' in the bottom right. Again Click 'Launch' in the bottom right.

14. In the resulting popup, select "proceed without a key pair" from the dropdown.  Ensure the box labeled 'I acknowledge...' and click 'Launch Instance' in the bottom right.
	
 ![Step 17](https://github.com/jharner/rspark/blob/master/AWS/image9.jpg)


15. On the next page, click 'View Instances' on the very bottom right of the page.

 ![Step 18](https://github.com/jharner/rspark/blob/master/AWS/image16.jpg)


16. On the instances screen, click on your newly created instance and copy down the IP address listed for your instance under the 'IPv4 Public IP' which can be found on the lower half of the screen.

![Step 19](https://github.com/jharner/rspark/blob/master/AWS/image18.jpg)


You may now connect to your Rspark server through a web browser:

17. Into a browser's URL bar, enter 'http://0.0.0.0:8787' replacing '0.0.0.0' with the IP address of your instance copied from step 16

18. Log into Rstudio with the credentials:

		username: rstudio
		password: rstudio

IMPORTANT:  When you have finished using Rspark and saved any needed files to your personal computer's filesystem, terminate your EC2 instance by selecting the instance in AWS and clicking the button labeled 'Actions' then clicking 'Instance State' and finally 'Terminate'.  If you neglect to terminate your EC2 instance you will be charged by Amazon for the duration it is left running.

Notes:

When you are finished working with Rspark, be sure to download all important work to your local computer and follow these steps to suspend the machine so that you are not charged for server runtime while it is not actively being used.  

1. Return to your [personal AWS Instances Dashboard](https://console.aws.amazon.com/ec2/v2/#Instances:sort=instanceId)

2. Select your running Rspark instance

3. Once your instance is selected, click 'Action' above the Instances list.

![Step 19](https://github.com/jharner/rspark/blob/master/AWS/image17.jpg)

4. Next click 'Instance State' from the dropdown and then click 'Stop'.

NOTE: The next time you Start the instance, using these same steps, but replacing the final 'Stop' with 'Start', your instance will have a NEW IP address for connecting to Rstudio.  Be sure to copy down the new IP and connecting just as you did in steps 16 - 18.


