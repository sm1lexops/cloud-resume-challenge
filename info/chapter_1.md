# Chapter 1: Create a project with AWS Management Console

- [Chapter 1: Create a project with AWS Management Console](#chapter-1--create-a-project-with-aws-management-console)
  * [Step 1: Domain Configuration and SSL Certificates](#step-1--domain-configuration-and-ssl-certificates)
  * [Step 2: Setting Up AWS S3 Bucket and Deploy Your Website](#step-2--setting-up-aws-s3-bucket-and-deploy-your-website)
  * [Step 3: Setting Up AWS CloudFront](#step-3--setting-up-aws-cloudfront)
  * [Step 4: Setting Up Route53](#step-4--setting-up-route53)

## Step 1: Domain Configuration and SSL Certificates

The organization that governs domain names is called the Internet Corporation for Assigned Names and Numbers (ICANN) 
and it has made it impossible for anyone to acquire a domain name forever.

* Buy domain name with `AWS Route 53` service or another `Registrars` for example, the best in my opinion [Porkbun](https://porkbun.com)

![register domain](../assets/chapter1/register_domain.jpg)

> Create Route 53 `hosted zone`

![hosted zone](../assets/chapter1/hosted_zone.jpg)

> If you bought domain name not from AWS you'll need to reconfigure `AUTHORITATIVE NAMESERVERS` 

* Copy from created `hosted zone` your four `NS` records 

![ns records](../assets/chapter1/a_name_servers.jpg)

* Configure and Paste to your domain name registrar DNS records

> example for `porkbun` 

![porkbun ns](../assets/chapter1/domain-nameservers.jpg)

Distribution `NS` records on the top-level domain (TLD) can take from 5 minutes to 12 hours

* Next, enhance the security of your website by acquiring an `SSL` certificate through `AWS Certificate Manager (ACM)` to enable secure communication. Request a public certificate for your new domain, `thevopz_yourdomain.com`, and include a wildcard domain, `thevopz_yourdomain.com`, to ensure robust encryption and security for all subdomains under `thevopz_yourdomain.com`, utilizing a single comprehensive certificate.

![cert_request](../assets/chapter1/cert_req.jpg)

> Click `next` SSL Cert config

![ssl cert config](../assets/chapter1/ssl_config_cert.jpg)

> Create ssl cert

The certificate will initially appear as `Pending validation` as the certificate authority (CA) verifies domain ownership or control. Please be patient until the status transitions to `Issued`. As soon as we have created our domain and the SSL certificate, we should create ."

* Go to AWS Certificate Manager (ACM) choose your *successfully* created SSL cert and click <button name="button">Create records in Route53</button>

![ssl records cert](../assets/chapter1/cert_records_route53.jpg)

## Step 2: Setting Up AWS S3 Bucket and Deploy Your Website

To initiate our setup, we leverage Amazon S3 as a storage solution for our website HTML, CSS, and JavaScript files. S3, renowned for its high durability and scalable object storage, stands as an optimal choice for hosting static content. Begin by creating an S3 bucket where you can securely store and manage your website’s files. Choose a unique Name and Region that suits your requirements.

* Create an s3 bucket as shown in the screenshot, leave the rest of the settings as default

![s3 bucket config](../assets/chapter1/create_bucket.jpg)

> For best compatibility, we recommend that you avoid using dots (.) in bucket names, except for buckets that are used only for static website hosting. If you include dots in a bucket's name, you can't use virtual-host-style addressing over HTTPS, unless you perform your own certificate validation. This is because the security certificates used for virtual hosting of buckets don't work for buckets with dots in their names.
This limitation doesn't affect buckets used for static website hosting, because static website hosting is only available over HTTP.


* Now you can **Upload** your website source code to s3 bucket, for this

  * Install AWS CLI
  * Configure AWS credentials in the cli `aws configure`
  * Check that you see your s3 bucket `aws s3 ls`
  * Upload your resume website source code to s3 bucket `aws s3 cp </your directory with source code> <s3 bucket name> --recursive` 

## Step 3: Setting Up AWS CloudFront

CloudFront efficiently caches and disseminates your website’s content across a global network of edge locations, effectively minimizing latency and enhancing the overall user experience.

> When establishing the distribution 
1. Designate the S3 bucket as the **Origin Domain** for my example `thevopz.com.s3.us-east-1.amazonaws.com`

2. Select `Origin access control settings(recommended)` under **Origin Access**. Origin Access Control (OAC) in CloudFront is a key feature that enables you to limit access to your origin server, ensuring that only specified CloudFront distributions can interact with it.

![distribution config 1](../assets/chapter1/create_distribution_1.jpg)

3. Click on the <button name="button">Create control setting</button> for Origin access control => choose for your s3 bucket

4. In the field below **Viewer** change *Viewer protocol policy* to `Redirect HTTP to HTTPS`

![distribution config 1](../assets/chapter1/create_distribution_2.jpg)

5. below in the settings *Alternate domain name (CNAME) - optional* click the button <button name="button">Add item</button> and paste two records `<your_domain>` and next `www.<your_domain>`

6. In the field below **Settings** settings *Custom SSL certificate - optional* change blank to `<your SSL certificate>` generated in the **Step 1**

7. In the field below *Default root object - optional* change blank to `/index.html`

![distribution config 1](../assets/chapter1/create_distribution_3.jpg)

8. Leave the rest of the settings as default and click <button name="button">Create distribution</button>

9. When you create the "Distribution", you will see *Warnings* that you need to update your `Bucket Policy`, click <button name="button">Copy Policy</button>

![bucket policy](../assets/chapter1/bucket_policy.jpg)

10. Go to your s3 bucket for resume website and in the 3rd tab **Permissions** in the field <Bucket policy> to the right click <button name="button">Edit</button>, and *paste* your copied distribution policy click <button name="button">Save changes</button>

![cf distribution domain name](../assets/chapter1/cf_distribution.jpg)

11. Copy your CloudFront distribution domain name and open link in a browser, you should see your webpage

![my website cf](../assets/chapter1/my_website.jpg)

## Step 4: Setting Up Route53

- [x] We bought a custom domain name 

- [x] We created a `hosted zone` for our resume website

- [x] We have generated and added an SSL **CNAME** records for our domain name in the route 53 `hosted zone` entry

For use custom domain name in your browser we should create `A` records type with routing traffic rule to **Alias to CloudFront distribution** 

* Create two `A` records for blank domain name and `www` domain name, choose settings like in a picture

![route53 records](../assets/chapter1/route53_a_records.jpg)

> Finally you should get something like this (6 records), and now you can use custom domain name for your website

![finall route53](../assets/chapter1/finall_route53.jpg)

**Tell your neighbors send a link to your friends now you're on the World Wide Web:)**

## Step 5: Setting Up Lambda and DynamoDB

Now we are set to enhance our project by implementing crucial improvements and addressing conditions 7 to 11 in our Cloud Resume Challenge.

* Our resume webpage should include a visitor counter that displays how many people have accessed the site. We will need to write a bit of Javascript to make this happen.

* We will retrieve the visitor counter and update its count in a DynamoDB database using a Lambda function written in Python code.

### Create DynamoDB Table

1. Navigate in the AWS Management Console `DynamoDB` on the main **Dashboard** click <button name="button">Create table</button>

2. Fill in the *Table name* `<your table name>`, next fill to *Partition key* field name `id`, next fields leave as default 

![db table](../assets/chapter1/dbtable.jpg)

3. Next click <button name="button">Explore table items</button>, you should creat <button name="button">Create item</button>, fill `views` value for `id` and create new **Attribute** *number* like in the picture

![table item](../assets/chapter1/db_item.jpg)

> You should have something like this

![db created table](../assets/chapter1/db_created_item.jpg)

### Configure Lambda function

1. Navigate in the AWS Management Console `Lambda` click <button name="button">Create function</button>

Fill fields:

* **Function name** `<your name>`

* **Runtime** choose lattest supported `Python`

* **Architecture** `x86_64`

* In **Advanced settings** enable - [x] `Enable function URL`, choose **Auth type** `NONE`, **Invoke mode** `BUFFERED(default)` and enable CORS - [x] `Configure cross-origin resource sharing (CORS)`

* Click <button name="button">Create function</button>

2. Add Python code to your lambda function

```py
#This section imports necessary libraries, including json and boto3 for working with AWS services.
import json
import boto3

#Here, an instance of the DynamoDB resource and a reference to the '<your dynamodb table name>' table are created.
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('<your dynamodb table name>')

#The Lambda function is triggered with an event and context.
def lambda_handler(event, context):
    #The subsequent code is wrapped in a try-except block to catch and handle any exceptions that might occur during execution.
    try:
        # Retrieve current views
        response = table.get_item(Key={'id': 'number'})
        views = response.get('Item', {}).get('views', 0)

        # Increment views count
        views += 1
        print(f"Updated views: {views}")

        # Update DynamoDB with new views count
        response = table.put_item(Item={'id': 'number', 'views': views})

        return views

    except Exception as e:
        print(f"An error occurred: {e}")
        raise
```

3. Configure CORS settings, as illustrated in the image, to enhance security. To restrict calls to your Lambda function solely from `<your domain name>`, ensure proper CORS configuration.

![lambda cors](../assets/chapter1/lambda_cors.jpg)

4. In the same window copy Lambda **Function URL** to notepad for the next javascript code


## Step 6: Configure Visitor Counter Code

1. Create `index.js` file and add javascript code to this file

```js
//This line selects the HTML element with the class name "counter-number" and assigns it to the variable counter. This element is likely intended to display the view count.
const counter = document.querySelector(".counter-number");

//The code defines an asynchronous function named updateCounter. The async keyword is used to indicate that this function will perform asynchronous operations.
async function updateCounter() {
    try {
        //The code fetches data from a Lambda function using the fetch API. If the response status is not okay (not in the range 200-299), it throws an error.
        const response = await fetch("Your-LambdaFunction-URL");
        
        if (!response.ok) {
            throw new Error(`Failed to fetch data. Status: ${response.status}`);
        }
        //If the fetch is successful, it parses the JSON response and updates the content of the counter element with the retrieved data.
        const data = await response.json();
        counter.innerHTML = `This page has ${data} Views!`;

    } catch (error) {
        console.error(`An error occurred: ${error.message}`);
        // Handle error gracefully, e.g., show a fallback message or log the error
    }
}
//Finally, the updateCounter function is invoked, initiating the process of fetching data and updating the view count on the web page.
updateCounter();
```

2. Add reference to your `index.js` file in `index.html` file

```html
  <script src="/path/to/index.js"></script>
```

3. Add the `counter-number` class to the html code element of your web page

> for example

```html
<div class="counter-number"></div>
```

If you have already downloaded your source code to the S3 bucket, delete the modified 'index.html' file from the bucket and download the new file to update your website.
* In navigation pane AWS Management Console find *CloudFront*, go to the *distribution*

* Click <button name="button">Invalidation</button> tab

* Then <button name="button">Create invalidation</button> tab

* *Add object paths* paste `/index.html`  click <button name="button">Create invalidation</button>

*Your website will be updated and you should see visitor counter number*

In the next step, we will configure a CI/CD workflow to automate these processes.

## Step 7: Configure CI/CD Workflow


