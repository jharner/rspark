## Running Rspark on AWS  ##
DISCLAIMER: 
Amazon Web Services (AWS) allows users the ability to, among other services, create virtual machines in the AWS cloud.  Using AWS services will cost the user a rate based upon computing power and reservation duration.  In order to use Rspark with AWS, you will need to be prepared to pay for the cloud services you utilize.

Prerequisites:
	-	 Amazon Web Services Account
	-  Modern Browser (Edge, Chrome, or Firefox)

1. Navigate to AWS https://aws.amazon.com/

2. Log into your account by clicking the 'My Account' dropdown at the top-right of the page and selecting the 'AWS Management Console' option. If you do not have an AWS account, click the "Create account" button at the top-right of the page.

![Step 1](https://github.com/jharner/rspark/blob/master/AWS/Image1.jpg)



3. Once logged in, click the 'All Services' dropdown and select 'EC2' from the section titled 'Compute'.

![Step 2](https://github.com/jharner/rspark/blob/master/AWS/image13.jpg)



4. Click 'Instances' located in the left sidebar under the 'Instances' header.

![Step 2](https://github.com/jharner/rspark/blob/master/AWS/Image2.jpg)

5. Ensure that have the 'N. Virginia' region selected in the top-right toolbar and click the blue 'Launch Instance' button.

![Step 3](https://github.com/jharner/rspark/blob/master/AWS/Image3.jpg)
![Step 4](https://github.com/jharner/rspark/blob/master/AWS/Image4.jpg)



6. On the left sidebar, click 'Community AMIs'.

 ![Step 5](https://github.com/jharner/rspark/blob/master/AWS/Image5.jpg)



7. Enter 'rsparkbox' (without quotes) into the search bar labeled 'Search community AMIs'.

 ![Step 6](https://github.com/jharner/rspark/blob/master/AWS/Image6.jpg)


		
8. Click the blue 'Select' button to choose the rspark image.

 ![Step 7](https://github.com/jharner/rspark/blob/master/AWS/Image7.jpg)




9. Next, we choose the computing power we want our EC2 instance to have.  Select 't2.medium'.

 ![Step 8](https://github.com/jharner/rspark/blob/master/AWS/Image8.jpg)



10. Click the blue 'Review and Launch' button in the bottom-right.

11. Click the blue 'Launch' button in the bottom-right.

12. When asked to select a key, select "Continue without a key pair"

![Step 9](https://github.com/jharner/rspark/blob/master/AWS/Image9.jpg)



13. Click 'Launch instance'.

14. Click 'View Instances' in the bottom right.

In order to connect to our running instance, we will need to expose the necessary port through the AWS security group. 

16. On the left sidebar, click 'Security Groups' under the 'Network & Security' subheader.

![Step 11](https://github.com/jharner/rspark/blob/master/AWS/image11.jpg)




17. Select 'launch-wizard-1' from the list of security groups.

![Step 12 and Step 13](https://github.com/jharner/rspark/blob/master/AWS/image12.jpg)



18. On the lower half of the screen, select the 'Inbound' tab.

19. To add a rule, click the 'Edit' button within the 'Inbound' tab.

20. Click 'Add Rule' on the left side of the pop-up.

21. For the new rule, select 'Custom TCP' on the left-most dropdown menu.

 ![Step 10](https://github.com/jharner/rspark/blob/master/AWS/Image10.jpg)



22. Enter '8787' for the Port Range.

23. Select 'Anywhere' under the 'Source' column dropdown.

24. Click the blue 'Save' button on the bottom right.

25. Again click 'Instances' on the left sidebar.

26. Make a note of the IP address listed for your instance under the 'IPv4 Public IP' column or simply copy it to your computer's clipboard.

You may now connect to your Rspark server through a web browser:

27. Into a browser's URL bar, enter 'http://0.0.0.0:8787' replacing '0.0.0.0' with the IP address of your instance copied from step 26

33. Log into Rstudio with the credentials:

		username: rstudio
		password: rstudio

IMPORTANT:  When you have finished using Rspark and saved any needed files to your personal computer's filesystem, terminate your EC2 instance by selecting the instance in AWS and clicking the button labeled 'Actions' then clicking 'Instance State' and finally 'Terminate'.  If you neglect to terminate your EC2 instance you will be charged by Amazon for the duration it is left running.



