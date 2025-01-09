# Deploying 2048 game on AKS with ingress load balancer.
I created an Azure Kubernetes Service (AKS) cluster using Terraform. The code for the same can be found on GitHub [📂]([https://github.com/anuja2015/2048game_AKS_Ingress)
![Screenshot 2025-01-09 113132](https://github.com/user-attachments/assets/7d755678-376d-40b0-a360-1876ef5acaea)
![Screenshot 2025-01-09 113230](https://github.com/user-attachments/assets/613ba64a-4b81-409b-a35e-0292b4bc4c5e)

![Screenshot 2025-01-09 113923](https://github.com/user-attachments/assets/2ddc35a9-9461-4f0a-8c0e-741a6813758d)

### Steps to Set Up the Application Gateway:

1.	Create a Public IP for the Application Gateway
   
Execute the following Azure CLI command:

    az network public-ip create --name appgw-IP --resource-group aks-resource-group --allocation-method Static --sku Standard
    
🌟 Public IP created successfully!
![Screenshot 2025-01-09 114826](https://github.com/user-attachments/assets/dc9b4de1-587a-46ca-8dff-b5a4492b60a2)
![Screenshot 2025-01-09 115323](https://github.com/user-attachments/assets/19ab40e6-6f79-4ded-882c-80d2c95c41b2)


2.	Create a Separate Virtual Network and Subnet for the Application Gateway
   
Use the following Azure CLI command:

    az network vnet create --name appgw-vnet --resource-group aks-resource-group --address-prefixes "10.0.0.0/16" --subnet-name appgw-subnet --subnet-prefixes "10.0.0.0/24"
    
⚡ Virtual network and subnet ready!



Important Note: ⚠️ Ensure the address spaces of the two virtual networks (AKS cluster and application gateway) do not overlap.

3.	Create the Application Gateway
   
Run this Azure CLI command to create the application gateway:

    az network application-gateway create --name game2048-gw --resource-group aks-resource-group --sku standard_v2 --public-ip-address appgw-IP --vnet-name appgw-vnet --subnet appgw-subnet --priority 100
    
🎯 Application Gateway created successfully!
![Screenshot 2025-01-09 120134](https://github.com/user-attachments/assets/f92309d3-6d00-46d8-a432-47355e5a6f48)

### Enable the Application Gateway Ingress Controller (AGIC) Add-On:

1.	Navigate to the Azure portal and go to the AKS cluster (aks-k8s). 🖥️
   
2.	Under Settings, select Networking > Virtual network integration.
   
3.	Under Application Gateway ingress controller, click Manage.
   
4.	On the Application Gateway ingress controller page:
   
-  Check the box to enable the ingress controller. ✅
  
- Select the existing application gateway from the dropdown.
  
5.	Click Save 💾

![Screenshot 2025-01-09 120943](https://github.com/user-attachments/assets/547b84a4-5953-4287-8844-94c559798518)
![Screenshot 2025-01-09 122937](https://github.com/user-attachments/assets/37e10d84-0cff-4e25-a796-5e8c2ac507a6)

   
Important Note: 🔑 If the application gateway resides in a different resource group than the AKS cluster, the managed identity ingressapplicationgateway-{AKSNAME} (in my case - ingressapplicationgateway-aks-k8s) must have Network Contributor and Reader roles assigned for the application gateway's resource group.

### Configure Virtual Network Peering:

Enable bi-directional peering between the cluster's virtual network and the application gateway's virtual network using the following Azure CLI commands:

- From the application gateway's virtual network to the AKS virtual network:
  
      az network vnet peering create -g aks-resource-group -n AppgwtoAKS --vnet-name appgw-vnet --remote-vnet aks-vnet --allow-vnet-access
  
- From the AKS virtual network to the application gateway's virtual network:

   ![Screenshot 2025-01-09 124253](https://github.com/user-attachments/assets/287d95e2-321a-4681-b7b5-39d5f96bbc60)

    az network vnet peering create -g aks-resource-group -n AKStoAppgw --vnet-name aks-vnet --remote-vnet appgw-vnet --allow-vnet-access
  ![Screenshot 2025-01-09 124441](https://github.com/user-attachments/assets/a975b8aa-ec91-4644-9318-0d8a607348f7)

🔄 Peering enabled in both directions!

### Deploy the 2048 Game Application

1.	Deploy the application using the YAML file: [📂](https://github.com/anuja2015/2048game_AKS_Ingress/blob/master/2048deployment.yaml)
   
      kubectl apply -f 2048deployment.yaml
  	![Screenshot 2025-01-09 130526](https://github.com/user-attachments/assets/468e50c0-4778-4c29-bc1d-465ab4842db4)

🚀 Deployment created successfully!

2.	Create the ingress resource using the YAML file: [📂](https://github.com/anuja2015/2048game_AKS_Ingress/blob/master/Ingress-2048.yaml)
   
      kubectl apply -f Ingress-2048.yaml
  	![Screenshot 2025-01-09 133420](https://github.com/user-attachments/assets/837f4a2b-bd45-4d32-8cf9-43b6d36c5b7f)

🌐 Ingress resource created!

### Verify the Application
Now that the application gateway is set up to serve traffic to the AKS cluster, let’s verify that the application is reachable:

1.	Get the ingress IP address:
   
      kubectl get ingress -n game-2048
  	
Output:
      NAME           CLASS                       HOSTS   ADDRESS           PORTS   AGE
      ingress-2048   azure-application-gateway   *       172.203.141.130   80      5s
      
💡 IP Address: 172.203.141.130

2.	Use the IP address (172.203.141.130) to access the application in your browser. 🕹️🎉
![Screenshot 2025-01-09 133519](https://github.com/user-attachments/assets/60f0e45f-08a8-4e10-98eb-60b57c192bf0)



