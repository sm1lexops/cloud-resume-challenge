# Cloud-resume-challenge

- [Beginning](#cloud-project-for-developing-and-hosting-your-resume)

- [Challenges](#challenges)
- 
## *"Cloud project for developing and hosting your resume."*

![cloud-resume-challenge](assets/cloud-resume-challenge.png)

> This Challenge Came Up With [Forrest Brazeal](https://forrestbrazeal.com/2020/04/23/the-cloud-resume-challenge/) 

> At this project, we'll tackle all of these [Cloud Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/). `all conditions are clickable`

![Cloud Resume Architecture Diagram](assets/cloud-resume-arch.png)

## Challenges

1. [**Resume Format**](#resume-html5-and-css-format): Your resume should be in HTML format, not a Word document or PDF. Here's an example of the desired format.

2. **Styling**: Use CSS to style your HTML resume. It doesn't need to be overly fancy, but it should look more than just plain HTML.

3. **Deployment**: Host your HTML resume as an Amazon S3 static website. While services like Netlify and GitHub Pages are excellent for personal static site deployments, we prefer using S3 for this project.

4. **Security**: Ensure that the S3 website URL uses HTTPS for security. You'll need to utilize Amazon CloudFront for this.

5. **Custom Domain**: Point a custom DNS domain name to the CloudFront distribution, allowing access to your resume via a personalized domain (e.g., my-c00l-resume-website.com). You can use Amazon Route 53 or another DNS provider for this, usually costing about ten dollars to register.

6. **Visitor Counter**: Your resume webpage should feature a visitor counter displaying the number of site visitors. Implement this using JavaScript. Here's a helpful tutorial to get you started.

7. **Database**: Set up a visitor counter that retrieves and updates its count in a database. We recommend using Amazon's DynamoDB for this purpose. DynamoDB's on-demand pricing is cost-effective unless you need excessive data storage or retrieval. You can find a free course on DynamoDB here.

8. **API Development**: Create an API to interact with DynamoDB instead of direct communication from your JavaScript code. We suggest using AWS's API Gateway and Lambda services. Python, with the boto3 library for AWS, is a suitable choice for back-end programming. You can find a free Python tutorial here.

9. **Testing**: Include tests for your Python code. Here are some resources for writing effective Python tests.

10. **Infrastructure as Code**: Define your API resources (DynamoDB table, API Gateway, Lambda function) in an AWS Serverless Application Model (SAM) template and deploy them using the AWS SAM CLI. This approach, known as "infrastructure as code," saves time in the long run.

11. **Continuous Integration and Deployment (CI/CD)**: Set up a private GitHub repository for your back-end code and configure GitHub Actions. When you push updates to your SAM template or Python code, automated testing should occur. If the tests pass, the SAM application should get packaged and deployed to AWS.

12. **Website Updates**: Create a second private GitHub repository for your website code. Configure GitHub Actions so that when you push new website code, the S3 bucket automatically updates. Be cautious not to expose AWS credentials in your source control.

13. **Blog Post**: Include a link in your resume to a brief blog post describing what you learned during this project. Dev.to is a great platform for publishing if you don't have your blog.

14. **Completion**: Once you've completed all these steps, add my GitHub username (@forrestbrazeal) as a collaborator on your repositories. If you meet the conditions mentioned above, I'll provide a personalized code review and help promote your work.

## Resume HTML5 and CSS Format

For my website I personally used [HTML5 UP](https://html5up.net/) template.

* Download template from [This site](https://html5up.net/).

* Build your website using some IDE, I personally used [SDE gitpod.io](https://gitpod.io).

* Zip the project code of your website for use in `AWS S3` .

> You can look at my sample code 

* [Commit Example #1]()

> Template 

![Template1](assets/template1.png)

* [Commit Example #2]()

