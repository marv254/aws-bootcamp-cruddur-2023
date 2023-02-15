# Week 0 — Billing and Architecture
From the security consideration topic i learned how to implement MFA on root and IAM users, i also learned its good practice not to create any workloads with the root user so I created an admin user(devopsmarv) account and give it admin priviledges.

![MFA](https://user-images.githubusercontent.com/60808086/219046309-5ff392b5-6ed5-4689-b6bb-985df5272487.png)
IAM user assigned with Admin priviledges
![Admin user](https://user-images.githubusercontent.com/60808086/219047559-a1bf7f94-3873-4308-968f-4c311caa9172.png)

I also learned how to create roles and assign them to users, for example in my case i created a role that would give full ec2 permissions to a user by attaching a custom policy.
![Roles](https://user-images.githubusercontent.com/60808086/219048624-917bb631-6b87-4ecd-b25f-67674caf7db8.png)

From the architectural design i learned how to design conceptual and logical design using Lucid Charts

Conceptual architectural Design for Cruddur Application

Link: https://lucid.app/lucidchart/dd14e134-83b7-4ca7-8e40-cfac82a86d2a/edit?viewport_loc=-324%2C93%2C2532%2C1272%2Cj3qxtr2tiIz0&invitationId=inv_fcc4e7f7-a535-4e3a-85ea-71d09c88bd2f
![Week 0 - Conceptual Diagram](https://user-images.githubusercontent.com/60808086/219034429-0d46bcf8-5512-4773-a2fd-9ce83d746dab.jpeg)

Logical Architectural Design for Cruddur Application

Link: https://lucid.app/lucidchart/a980feaf-805e-461f-9b79-8564f59ba969/edit?viewport_loc=-91%2C120%2C2219%2C1031%2C0_0&invitationId=inv_05e38fdc-e37a-4198-92cd-a36f9ca3a1de
![Week 0 - Billing   Architecture - Logical App Design](https://user-images.githubusercontent.com/60808086/219035595-1e389852-4d9a-46aa-a225-09607c17319c.jpeg)

Logical CI/CD pipeline architectural Design

Link: https://lucid.app/lucidchart/a980feaf-805e-461f-9b79-8564f59ba969/edit?viewport_loc=72%2C175%2C2219%2C1031%2C47pxRwn913Zy&invitationId=inv_05e38fdc-e37a-4198-92cd-a36f9ca3a1de
![Week 0 - Billing   Architecture - Logical CI-CD ](https://user-images.githubusercontent.com/60808086/219036383-4964c884-d2da-4b05-be55-2af433fdf85f.jpeg)

From the billing topic, I learned how to create budgets so that when i exceed a certain threshold on my aws spending i get notified via email. This helps you in tracking your costs.
![budgets](https://user-images.githubusercontent.com/60808086/219052663-7f936a4a-989d-426d-8aef-612d53066bb6.png)
