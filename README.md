# DataEngineeringZoomCamp

**Module 1**

what is Docker? It delivers **software** in packages called **container**. Containers are **isolated** from another one. 
Pipeline is a process or a service that takes in data and produces more data. In another hand, it is a means to transfer data from somewher to somewhere else. Along the way, data is transformed and optimized , arriving in a state that can be used by engineerings.The whole idea of docker for developer is to develop applocationes, ship them into containars and then run them anywhere.

why should we care about docker?
1- reproducibility

2- Local experiments

3- Integration test (CI/CD): to test a real complicated pipline locally to make sure what it is doing. so we can come up with a bunch of tests to make sure that its behaviour is what we expect. to get more information, you can look up something like GitHub action, and GitHub CI/CD.

**installing Docker:**

 **Useful links:**
1) (https://www.bing.com/videos/riverview/relatedvideo?q=how+to+install+docker+on+windows+11+youtube+video&mid=644C3A72ADF568CFFCA1644C3A72ADF568CFFCA1&FORM=VIRE)
2) Docker Home Page - https://www.docker.com/
3) Docker Windows Download Page - https://www.docker.com/products/docke...
4) Docker System Requirements - https://docs.docker.com/desktop/insta...
5) Step by Step Fix Manual - https://learn.microsoft.com/en-us/win...

Requirements:
1- check if WSL (windows subsystem for Linux) is on in your system:
In search box, type and open: “turn Windows features on or off”:
Check Windows hypervisor platform
Check Windows subsystem for Linux
Restart computer to complete the installation process if it asked
After restarting computer, in CMD window type: wsl –status: I got following output:

![Sample Image](images/wsl_status.png)

- Just to check the things are fine:
  Wsl –update
- Optional: To change the version of wsl, type in cmd: –set-default-version 2
- Download docker from Windows | Docker Docs and install it. 
- After restarting, if you get following window, it means you have installed docker successfully. 

