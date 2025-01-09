# Deploying 2048 game on AKS with ingress load balancer.
I created an Azure Kubernetes Service (AKS) cluster using Terraform. The code for the same can be found on GitHub [📂]([https://github.com/anuja2015/2048game_AKS_Ingress)

### Steps to Set Up the Application Gateway:

1.	Create a Public IP for the Application Gateway
   
Execute the following Azure CLI command:

    az network public-ip create --name appgw-IP --resource-group aks-resource-group --allocation-method Static --sku Standard
    
🌟 Public IP created successfully!

2.	Create a Separate Virtual Network and Subnet for the Application Gateway
   
Use the following Azure CLI command:

    az network vnet create --name appgw-vnet --resource-group aks-resource-group --address-prefixes "10.0.0.0/16" --subnet-name appgw-subnet --subnet-prefixes "10.0.0.0/24"
    
⚡ Virtual network and subnet ready!

Important Note: ⚠️ Ensure the address spaces of the two virtual networks (AKS cluster and application gateway) do not overlap.

3.	Create the Application Gateway
   
Run this Azure CLI command to create the application gateway:

    az network application-gateway create --name game2048-gw --resource-group aks-resource-group --sku standard_v2 --public-ip-address appgw-IP --vnet-name appgw-vnet --subnet appgw-subnet --priority 100
    
🎯 Application Gateway created successfully!

### Enable the Application Gateway Ingress Controller (AGIC) Add-On:

1.	Navigate to the Azure portal and go to the AKS cluster (aks-k8s). 🖥️
   
2.	Under Settings, select Networking > Virtual network integration.
   
3.	Under Application Gateway ingress controller, click Manage.
   
4.	On the Application Gateway ingress controller page:
   
-  Check the box to enable the ingress controller. ✅
  
- Select the existing application gateway from the dropdown.
  
5.	Click Save 💾
   
Important Note: 🔑 If the application gateway resides in a different resource group than the AKS cluster, the managed identity ingressapplicationgateway-{AKSNAME} (in my case - ingressapplicationgateway-aks-k8s) must have Network Contributor and Reader roles assigned for the application gateway's resource group.

### Configure Virtual Network Peering:

Enable bi-directional peering between the cluster's virtual network and the application gateway's virtual network using the following Azure CLI commands:

- From the application gateway's virtual network to the AKS virtual network:
  
      az network vnet peering create -g aks-resource-group -n AppgwtoAKS --vnet-name appgw-vnet --remote-vnet aks-vnet --allow-vnet-access
  
- From the AKS virtual network to the application gateway's virtual network:
  
    az network vnet peering create -g aks-resource-group -n AKStoAppgw --vnet-name aks-vnet --remote-vnet appgw-vnet --allow-vnet-access
  
🔄 Peering enabled in both directions!

### Deploy the 2048 Game Application

1.	Deploy the application using the YAML file: [📂](https://github.com/anuja2015/2048game_AKS_Ingress/blob/master/2048deployment.yaml)
   
      kubectl apply -f 2048deployment.yaml
  	
🚀 Deployment created successfully!

2.	Create the ingress resource using the YAML file: [📂](https://github.com/anuja2015/2048game_AKS_Ingress/blob/master/Ingress-2048.yaml)
   
      kubectl apply -f Ingress-2048.yaml
  	
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



