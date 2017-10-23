## Running Rspark on AWS  ##
DISCLAIMER: 
Amazon Web Services (AWS) allows users the ability to, among other services, create virtual machines in the AWS cloud.  Using AWS services will cost the user a rate based upon computing power and reservation duration.  In order to use Rspark with AWS, you will need to be prepared to pay for the cloud services you utilize.

Prerequisites:
	-	 Amazon Web Services Account
	-  MacOS or Linux operating system (or an understanding of the Windows CLI)
	-  Some familiarity with a command line
	-  Modern Browser (Edge, Chrome, or Firefox)

1. Navigate to AWS https://aws.amazon.com/

	** Image 1 **
2. Log into your account by clicking the 'My Account' dropdown at the top-right of the page and selecting the 'AWS Management Console' option. If you do not have an AWS account, click the "Create account" button at the top-right of the page.

	** Image 2 **
3. Once logged in, select 'EC2' from the section titled 'Compute'.

  ** Image 2 ** 
4. Click 'Instances' located in the left sidebar.

	** Image 3 & Image 4 **
5. Ensure that have the 'N. Virginia' region selected in the top-right toolbar and click the blue 'Launch Instance' button.

	** Image 5 **
6. On the left sidebar, click 'Community AMIs'.

	** Image 6 **
7. Enter 'rsparknew' (without quotes) into the search bar labeled 'Search community AMIs'.

	** Image 7 **
8. Click the blue 'Select' button to choose the rspark image.


	** Image 8 **
9. Next, we choose the computing power we want our EC2 instance to have.  Select 't2.medium'.

10. Click the blue 'Review and Launch' button in the bottom-right.

11. Click the blue 'Launch' button in the bottom-right.

You will now be asked to create an SSH-key, which will be necessary to control your EC2 instance.

	** Image 9 **
12. Select 'Create a new key pair' from the top dropdown. For the purpose of launching Rspark, name the key pair 'rspark'.

13. Click 'Download Key Pair' and **move the file to your desktop.** (this is important)

14. Click 'Launch instance'.

15. Click 'View Instances' in the bottom right.

In order to connect to our running instance, we will need to expose the necessary ports through the AWS security group. 

16. On the left sidebar, click 'Security Groups' under the 'Network & Security' subheader.

17. Select 'launch-wizard-1' from the list of security groups.

18. On the lower half of the screen, select the 'Inbound' tab.

19. To add a rule, click the 'Edit' button within the 'Inbound' tab.

20. Click 'Add Rule' on the left side of the pop-up.

21. For the new rule, select 'Custom TCP' on the left-most dropdown menu.

	** Image 10 **
22. Enter '8787' for the Port Range.

23. Select 'Anywhere' under the 'Source' column dropdown.

24. Click the blue 'Save' button on the bottom right.

25. Again click 'Instances' on the left sidebar.

26. Make a note of the IP address listed for your instance under the 'IPv4 Public IP column' or simply copy it to your computer's clipboard.

We will now connect to the EC2 instance we creating using a Secure Shell (SSH) login.

27. Open your computer's system application called 'Terminal'.

28. Enter the following commands (without quotes) one at a time into the terminal: 
		
		'cd Desktop'
		'chmod 400 rspark.pem'

29. You will need to paste the IP address we copied down in step #26 into the following command (without quotes):

		(replace 00.00.00.00 with the copied IP address)
		'ssh -i rspark.pem ubuntu@00.00.00.00'

30. When prompted to accept your instance's fingerprint, type 'yes' and press enter.

You should now be logged into your instance through an SSH connection.

31. In order to start Rspark on this instance, enter the following commands.

		'cd rspark'
		'docker-compose up'

32.  You may now connect to the Rstudio session running on your instance by navigating to the following URL in your browser.  NOTE: You will again need to paste in the IP address noted in step 26

		http://00.00.00.00:8787

33. Log into Rstudio with the credentials:

		username: rstudio
		password: rstudio

IMPORTANT:  When you have finished using Rspark and saved any needed files to your personal computer's filesystem, terminate your EC2 instance by selecting the instance in AWS and clicking the button labeled 'Actions' then clicking 'Instance State' and finally 'Terminate'.  If you neglect to terminate your EC2 instance you will be charged by Amazon for the duration it is left running.



