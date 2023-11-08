# Lab. #6 - Operating Cloud Native Applications

Hello, in this lab you will learn how to record, monitor and analyze the logs of the OCI Compute infrastructure that you provisioned in the previous labs using the **Oracle Cloud Observability and Management Platform**!

- 🌀 [Official website of OCI Observability and Management Platform](https://www.oracle.com/manageability/)
- 🧾 [Documentation for OCI Logging](https://docs.oracle.com/en-us/iaas/Content/Logging/Concepts/loggingoverview.htm)
- 🧾 [Documentation for OCI Logging Analytics](https://docs.oracle.com/en-us/iaas/logging-analytics/index.html)

**Here's a step-by-step guide to setting this up:**

- [Pre Reqs: Log in to your OCI account](#PreReqs)
- [Step 1: Activate the Logging service and enable log collection](#Step1)
- [Step 2: Activate the Logging Analytics service and create a group for the Logs](#Step2)
- [Step 3: Create the Service Connector to replicate the Logging logs to Logging Analytics](#Step3)
- [Step 4: Configure customized queries and create a dashboard](#Step4)

- - -

## <a name="PreReqs"></a> Pre Reqs: Create a Slack channel and log in with your OCI account

 1. Do the [login](https://www.oracle.com/cloud/sign-in.html) in your OCI account;
 2. Run the [Lab. #1](../Lab.%20%231%20-%20Resource%20Provisioning), if you haven't run it before;

---

## <a name="Step1"></a> Step 1: Activate the Logging service and enable log collection

1. In the 🍔 hamburger menu, go to: **Networking** → **Capture Filters**:
![](images/captureFilters.png)
2. In the **Capture Filters** page, click on **Create capture filter**:
![](images/createCaptureFilter.png)
3. Choose the correct compartment, select **Flow log capture filter** and select **10%** of **Sampling Rate**:
![](images/1CreateCFilter.png)
4. Do not change anything form the **Rules** section and click in the **Create capture filter** button
![](images/2CreateCFilter.png) 
5. In the 🍔 hamburger menu, go to: **Observability and Management Platform** → **Logging**:
![](https://github.com/ladan19/images-lp/blob/main/photo-2.png?raw=true)
6. In the **Logging** menu on the left, click on **Logs** and then on the button on the right **Enable service log**:
![](https://github.com/ladan19/images-lp/blob/main/photo-3.png?raw=true)
7. Under **Service** choose the item *Virtual Cloud Network* and under **Resource** select the public subnet created earlier. In **Log Category** select the *Flow Logs* option and in **Log Name** enter the name *Flowlogs-VCN*. Then in Log Location click on **Show Advanced Options** and click on **Create New Group** to create a new group:
![](https://github.com/ladan19/images-lp/blob/main/photo-4.png?raw=true)
8. On the log group creation screen, in **Name** enter the group name *LogGroupFlow* and click on the **Create** button:
![](https://github.com/ladan19/images-lp/blob/main/photo-5.png?raw=true)
9. Leave *LogGroupFlow* selected as **Log Group** and click on the **Enable Log** button to enable the configuration:
![](https://github.com/ladan19/images-lp/blob/main/photo-6.png?raw=true)
10. After activation (2-3 min), log collection begins (5-6 min). To view **Logging**, click on **Logs** in the left-hand menu and then click on the Log Name we just created **Flowlogs-VCN**:
![](https://github.com/ladan19/images-lp/blob/main/photo-7.png?raw=true)
11. You will see the log collection dashboard for the chosen VCN. Click on **Explore with Log Search** on the right to:
![](https://github.com/ladan19/images-lp/blob/main/photo-8.png?raw=true)
12. Done! From now on you can modify the searches to filter out the log you want.

> Tip: Change the visualization to **Visualize** and have fun!


---

## <a name="Step2"></a> Step 2: Activate the Logging Analytics service and create a group for the Logs

1. Go to the 🍔 hamburger menu: **Observability and Management Platform** → **Logging Analytics** :
![](https://github.com/ladan19/images-lp/blob/main/photo-10.png?raw=true)
2. Activate by clicking on the **Start Using Logging Analytics**:
![](https://github.com/ladan19/images-lp/blob/main/photo-11.png?raw=true)
3. After initialization, click on the **Take me to Log Explorer**:
![](https://github.com/ladan19/images-lp/blob/main/photo-12.png?raw=true)

> Tip: Notice that the service already creates some policies and a *Default* log group.

5. In the Log Explorer console in the top menu on the left, click and select **Administration**:
![](https://github.com/CeInnovationTeam/OCI-FastTrack-Developer-LINUXtips/blob/main/Lab.%20%235%20-%20Operating%20Cloud%20Native%20Applications/images/Image02.png?raw=true)
6. Now click on **Log Groups** in the **Resources** menu and then on the **Create Log Group** button to create a new log group:
![](https://github.com/ladan19/images-lp/blob/main/photo-13.png?raw=true)
![](https://github.com/ladan19/images-lp/blob/main/photo-14.png?raw=true)
7. In the Log group creation console, in **Name** enter the group name *LogGroupVCN* and then click the **Create** button:
![](https://github.com/ladan19/images-lp/blob/main/photo15.png?raw=true)

---

## <a name="Step3"></a> Step 3: Create the Service Connector to replicate the Logging logs to Logging Analytics

1. In the 🍔 hamburger menu, go to: **Observability and Management Platform** → **Service Connectors**:
![](https://github.com/ladan19/images-lp/blob/main/photo-16.png?raw=true)
3. In the *Service Connectors* console, click on the **Create Service Connector** button:
![](https://github.com/CeInnovationTeam/OCI-FastTrack-Developer-LINUXtips/blob/main/Lab.%20%235%20-%20Operating%20Cloud%20Native%20Applications/images/Image03.png?raw=true)
1. In **Connector Name** enter *LogVCNConnector*, in **Configure Source** select *Logging* and in **Target** select *Logging Analytics*. In the *Configure Source* section, in **Log Group** select *LogGroupFlow* and in **Logs** select the *FlowLogs-VCN* created earlier:
![](https://github.com/ladan19/images-lp/blob/main/photo17.png?raw=true)
1. Under **Configuration Target** select the **Log Group** *LogGroupVCN* and (Very Important :warning:) click on the **Create** button on the right _to create the policies for the connector to have write permission_. Then click on the **Create** button at the bottom left to create the connector:
![](https://github.com/ladan19/images-lp/blob/main/photo-18.png?raw=true)

---

## <a name="Step4"></a> Step 4: Configure customized queries and create a dashboard

1. In the 🍔 hamburger menu, go to: **Observability and Management Platform** → **Log Explorer**:
![](https://github.com/ladan19/images-lp/blob/main/photo-19png.png?raw=true)
2. In the **Log Explorer** console, replace the existing query with the query below to search for the source IPs that are accessing the VCN we have configured and click on the **Run** button:

```sh
'Log Source' = 'OCI VCN Flow Unified Schema Logs' | stats count as logrecords by 'Source IP'
```

![](https://github.com/ladan19/images-lp/blob/main/photo-21.png?raw=true)

> Tip: If the message *No data has been ingested* appear in the **Log Explorer**, give it some time to collect data and refresh the page.

3. We'll save the result of the query for use in creating our dashboard next. Click on **Actions** in the menu on the right and then on **Save**, type *Input Ips* in **Search Name** and click on the **Save** button:
![](https://github.com/CeInnovationTeam/OCI-FastTrack-Developer-LINUXtips/blob/main/Lab.%20%235%20-%20Operating%20Cloud%20Native%20Applications/images/Image06.png?raw=true)
4. Set up another custom query to find out the volume of outgoing traffic from the VCN. replace the existing query with the one below, change the display to a **Line** graph and click on the **Run** button:

```sh
'Log Source' = 'OCI VCN Flow Unified Schema Logs' | timestats avg('Content Size Out') as 'Outbound Traffic'
```

![](https://github.com/ladan19/images-lp/blob/main/photo-23.png?raw=true)

5. Click on **Actions** in the menu on the right and under **Save as...**, type *Outgoing Traffic* in **Search Name** and click on the **Save** button:
![](https://github.com/CeInnovationTeam/OCI-FastTrack-Developer-LINUXtips/blob/main/Lab.%20%235%20-%20Operating%20Cloud%20Native%20Applications/images/Image05.png?raw=true)

> Tip: Use **Save as..** instead of **Save** to be able to save the result under a new name.

6. Select **Dashboard** from the menu on the top left:
![](https://github.com/ladan19/images-lp/blob/main/photo-26.png?raw=true)
7. In the **Dashboard** console, click on the **Create Dashboard** button:
![](https://github.com/ladan19/images-lp/blob/main/photo-27.png?raw=true)
8. In the dashboard creation console, select the compartment under **Widget Compartment** and drag and drop the **Input Ips** widget:
![](https://github.com/ladan19/images-lp/blob/main/photo-28.png?raw=true)
10. After dragging the widget, you will be asked to create a filter. We'll add a new filter, leave the **Log Group Compartment** selection and click on the **Save Changes** button:
![](https://github.com/CeInnovationTeam/OCI-FastTrack-Developer-LINUXtips/blob/main/Lab.%20%235%20-%20Operating%20Cloud%20Native%20Applications/images/Image07.png?raw=true)
11. For the **Entity** configuration, leave the *Entity* selection and click on the **Save Changes** button:
![](https://github.com/CeInnovationTeam/OCI-FastTrack-Developer-LINUXtips/blob/main/Lab.%20%235%20-%20Operating%20Cloud%20Native%20Applications/images/Image08.png?raw=true)
12. The widget will be added to the dashboard in this way:
![](https://github.com/ladan19/images-lp/blob/main/photo-30.png?raw=true)
13. Carry out the same process as before by clicking on the **Add widget** tab for the **Outgoing Traffic** widget:
![](https://github.com/ladan19/images-lp/blob/main/photo-31.png?raw=true)
14. Change the dashboard name by clicking on the **Pencil** icon, type *VCN Dashboard* and hit enter to save the name. Then select the **About** tab, select a compartment and click on the **Save Changes** button:
![](https://github.com/ladan19/images-lp/blob/main/photo-33.png?raw=true)

---

### 👏🏻 Congratulations!!! You have successfully set up a complete **Logging** and **Logging Analytics** pipeline in OCI! 🚀
