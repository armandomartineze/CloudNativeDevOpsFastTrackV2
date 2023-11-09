# Lab. #4 - Securing Cloud Native Applications

In this step, you will secure your Cloud Native Apps using the Web Application Firewall! This service allows us to protect our application from from malicious and unwanted internet traffic!

- 🌀 [Official OCI WAF page](https://www.oracle.com/security/cloud-security/web-application-firewall/)
- 🧾 [OCI WAF documentation](https://docs.oracle.com/en-us/iaas/Content/WAF/Concepts/overview.htm)

**You'll learn the entire step-by-step of this implementation.
 - [Pre Reqs](#PreReqs)
 - [Step 1: Create de WAF](#Passo1)
 - [Step 1.2: Configure de WAF policies](#Passo2)
 - [Step 2: Test the Country/Region policy](#Passo3)
 - [Step 3: Test the injection of a script ](#Passo4)

 - - -

 ## <a name="PreReqs"></a> Pre Reqs

 1. [Log in](https://www.oracle.com/cloud/sign-in.html) to your OCI account

 2. Run the labs [Lab. #1](../Lab.%20%231%20-%20Resource%20Provisioning) and [Lab #2](../Lab.%20%232%20-%20Developing%20Cloud%20Native%20Applications%20-%20Parte%201).
 3. Get the Front-End Load Balancer name. In the 🍔 hamburger menu, go to: **Networking** → **Load Balnacer**. Save the name of the Load Balancer associated with the Front-End of [Lab #2](../Lab.%20%232%20-%20Developing%20Cloud%20Native%20Applications%20-%20Parte%201)
 
 That's it! We've fulfilled all the prerequisites for the lab!
 
 - - -

 ## <a name="Passo1"></a> Step 1: Create de WAF

 1. In the 🍔 hamburger menu, go to: **Identity and security** → **DevOps** → **Projects**.
    
 ![](./Images/013-LAB4.png)


 3. Clone the project repository.

 ```shell
 git clone https://github.com/CeInnovationTeam/BackendFTDev.git
 ```

 3. In the 🍔 hamburger menu, go to: **Developer Services** → **DevOps** → **Projects**.
  
 ![](./Images/014-LAB4.png)

 4. Access the listed project (created when provisioning the Resource Manager 😄).
  
 ![](./Images/015-LAB4.png)

 5. On the project page, click on **Create repository**.

 ![](./Images/016-LAB4.png)

 6. Fill in the form as follows:

   - **Name:** ftRepo
   - **Description:** (Define any description).
   - **Default branch:** main

 ![](./Images/017-LAB4.png)

 7. On the newly created repository page, click on **HTTPS** and:

- [1] Copy into notepad the information about the user to be used to work with git (**Git User**).
- 2] Copy the git clone command and run it in the Cloud Shell.

 ![](./Images/018-LAB4.png)

 8. In the Cloud Shell, when running the command, enter the newly copied **Git User** and your **Auth Token** as the password.

 9. At this point, the Cloud Shell should have two new directories:
 - BackendFTDev
 - ftRepo
 
 ![](./Images/019-LAB4.png)

 10. Run the following commands to copy the contents of the **BackendFTDev** repository to the **ftRepo** repository.

 ```shell
 git config --global user.email "<your-email>"
 git config --global user.name "<your-username>"
 cp -r BackendFTDev/* ftRepo/
 cd ftRepo
 git add -A
 git commit -m "Start of project"
 git push origin main
 ```

*Ao final do último comando o **Usuário git** e a senha (**Auth Token**) poderão ser solicitados novamente*.

 ## <a name="Passo2"></a> Passo 2: Criar e configurar processo de Build (CI)

 1. Retorne à página inicial do projeto DevOps.
 2. Clique em **Create build pipeline**. 

 ![](./Images/020-LAB4.png)

 3. Preencha o formulário da seguinte forma, e clique em **Create**:
   - **Name**: build
   - **Description**: (Defina uma descrição qualquer).

 ![](./Images/021-LAB4.png)

 4. Abra o pipeline de build recém-criado.
 5. Na aba parâmetros, defina os seguintes parametros:
  - APM_ENDPOINT: *Informação coletada nos pré requisitos*.
  - APM_PVDATAKEY: *Informação coletada nos pré requisitos*.
  - APM_AGENT_URL: [🔗 copie este link](https://objectstorage.us-ashburn-1.oraclecloud.com/p/oMebVKw5USHnxjbrBWM9mKNYN-8MED6LKreiZ8fl_TgrtesUJ5PYI7hfqDngZRgr/n/id3kyspkytmr/b/bucket-devft-apm/o/apm-java-agent-installer-1.8.3326.jar)

  **ATENÇÃO** - Ao inserir nome, valor e descrição, clique no sinal de "+" para que a informação fique salva.
  
 ![](./Images/022-LAB4.png)

 6. Acesse a aba de **Build Pipeline**, e clique em **Add Stage**.

 ![](./Images/023-LAB4.png)

 7. Selecione a opção **Managed Build** e clique **Next**.

 ![](./Images/024-LAB4.png)

 8. Preencha o formulário da seguinte forma:

- **Stage Name**: Criacao de artefatos
- **Description**: (Defina uma descrição qualquer).
- **OCI build agent compute shape**: *Não alterar*.
- **Base container image**: *Não alterar*.
- **Build spec file path**: *Não alterar*.
      
![](./Images/025-LAB4.png)


9. Em Primary code repository, clique em **Select**, selecione as opções abaixo e clique em **Save**. 

- **Source Connection type**: OCI Code Repository
- **Repositório**: ftRepo
- **Select Branch**: *Não alterar*
- **Build source name**: java_root
    
![](./Images/026-LAB4.png)

- Feito isto, clique em **Add**.

![](./Images/025_1-LAB4.png)

🤔 Neste momento é importante entender a forma como a ferramenta trabalha 📝.
    
- A ferramenta utiliza um documento no formato YAML para definir os passos que devem ser executados durante o processo de construção da aplicação.
- Por padrão este documento é chamado de *build_spec.yaml* e deve ser configurado previamente de acordo com as necessidades da aplicação.
- Os passos serão então executados por uma instância temporária (agent), que será provisionada no início de cada execução e destruída ao final do processo.
- 🧾 [Documentação de como formatar o documento de build](https://docs.oracle.com/pt-br/iaas/Content/devops/using/build_specs.htm)
- 📑 [Documento utilizado neste workshop (build_spec.yaml)](https://raw.githubusercontent.com/CeInnovationTeam/BackendFTDev/main/build_spec.yaml)

 ## <a name="Passo3"></a> Passo 3: Criar e configurar entrega de artefatos (CI)

 1. Na aba de Build Pipeline, clique no sinal de **"+"**, abaixo do stage **Criacao de artefatos**, e em **Add Stage**.
     
![](./Images/027-LAB4.png)


 2. Selecione a opção **Deliver Artifacts** e clique em **Next**.
     
![](./Images/028-LAB4.png)


 3. Preencha o formulário como abaixo e clique em **Create artifact**.
 - **Stage name**: Entrega de artefato
 - **Description**: (Defina uma descrição qualquer).

![](./Images/029_0-LAB4.png)

 4. Na opção de seleção de artefatos, preencha como abaixo e clique em **Add**.
- **Name**: backend_jar
 - **Type**: General artifact
 - **Artifact registry**: *Selecione o Artifact registry gerado pelo terraform de nome "artifact_repository"*.
- **Artifact location**: Set a Custom artifact location and version
- **Artifact path**: backend.jar
- **Version**: ${BUILDRUN_HASH}
- **Replace parameters used in this artifact**: Yes, substitute placeholders
       
![](./Images/030-LAB4.png)


5. Preencha o campo restante da tabela **Build config/result artifact name** com "app" e clique em **Add**.
    
![](./Images/029_1-LAB4.png)

 6. Na aba de Build Pipeline, clique no sinal de **"+"** abaixo do stage **Entrega de artefato** e em **Add Stage**.

 ![](./Images/031-LAB4.png)

 7. Novamente, clique em **Deliver Artifacts** e em **Next**.

 ![](./Images/028-LAB4.png)

 8. Preencha o formulário como abaixo e clique em **Create Artifact**.
 - **Stage name**: Entrega de Image de Container
 - **Description**: (Defina uma descrição qualquer).

 ![](./Images/033_0-LAB4.png)
 
 9. Em *Add artifact*, preencha o formulário como abaixo e clique em **Add**.
- **Name**: backend_img
- **Type**: Container image repository
- **Artifact Source**: `<código-de-região>.ocir.io/${IMG_PATH}`
- **Replace parameters used in this artifact**: Yes, substitute placeholders
   
*Para Ashburn e São Paulo, os códigos de região são respectivamente "iad" e "gru". Caso esteja em outra região, utilize a [tabela de refêrencia](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm)*.
       
![](./Images/032_0-LAB4.png)

9. Preencha o campo restante da tabela **Build config/result artifact name** com: docker-img e clique em **Add**.
       
![](./Images/033_1-LAB4.png)

<a name="FinalPasso3"></a> Isso conclui a parte de Build (CI) do projeto! Até aqui automatizamos a compilação do código java, criamos a imagem de contêiner, e armazenamos ambas nos repositórios de artefatos, e de imagens de contêiner respectivamente. Vamos agora para a parte de Deployment (CD)!

## <a name="Passo4"></a> Passo 4: Criar e configurar entrega de aplicação a cluster Kubernetes (CD)

1. No **Cloud Shell**, para a criação do secret, execute os comandos abaixo e informe o seu User OCID e Auth Token, coletados anteriormente.

 ```shell
  cd ftRepo/scripts/
  chmod +x create-secret.sh 
  ./create-secret.sh  
 ```

2. Aguarde o final do fluxo.
        
![](./Images/039-LAB4.png)

 3. Retorne ao seu projeto DevOps clicando no 🍔 menu hamburguer e acessando: **Developer Services**  → **Projects**.
 4. No canto esquerdo, selecione **Environments**.
         
![](./Images/040-LAB4.png)

 5. Clique em **Create New Environment**.

 6. Preencha o formulário como abaixo e clique em **Next**.
  - **Environment type**: Oracle Kubernetes Engine
  - **Name**: OKE
  - **Description**: OKE

 7. Selecione o Cluster de Kubernetes, e clique em **Create Envrinoment**.

 ![](./Images/041-LAB4.png)

 8. No canto esquerdo selecione **Artifacts** em seguida em **Add Artifact**.
          
![](./Images/042-LAB4.png)

 9. Preencha o formulario como abaixo e clique em **Add**.
 - **Name**: deployment.yaml
 - **Type**: Kubernetes manifest
 - **Artifact Source**: Inline
 - **Value**: Cole o conteúdo do arquivo https://github.com/CeInnovationTeam/BackendFTDev/blob/main/scripts/deployment.yaml
 *Não altere a identação (espaços) do documento, pois isso pode quebrá-lo*.
 - **Replace parameters used in this artifact**: Yes, substitute placeholders
          
![](./Images/043_0-LAB4.png)

 10. No canto esquerdo, selecione **Deployment Pipelines** e, em seguida, clique em **Create Pipeline**.
          
![](./Images/044-LAB4.png)

 11. Preencha o formulário como abaixo e clique em **Create pipeline**.
 - **Pipeline name**: deploy
 - **Description**: (Defina uma descrição qualquer).
          
![](./Images/048-LAB4.png)

 12. Na Aba de **Parameters** configure o seguinte parâmetro:
 
 - REGISTRY_REGION: `<código-de-região>`.ocir.io  
          
![](./Images/049-LAB4.png)

 13. Retorne à aba de **Pipeline** e clique em **Add Stage**.
          
![](./Images/050-LAB4.png)

 14. Selecione a Opção **Apply Manifest to your Kubernetes Cluster** e clique em **Next**.
          
![](./Images/051-LAB4.png)

 15. Preencha o formulário da seguinte forma:
 - **Name**: Deployment da Aplicacao
 - **Description**: (Defina uma Descrição qualquer).
 - **Environment**: OKE

![](./Images/052_0-LAB4.png)

16. Clique em **Select Artifact**, e selecione **deployment.yaml**.

![](./Images/052_1-LAB4.png)

17. Feito isto, clique em **Add**.
 
 Com isso finalizamos a parte de Deployment (CD) do nosso projeto! No passo a seguir vamos conectar ambos os pipelines, e definir um gatilho (trigger) para que o processo automatizado se inicie!

 ## <a name="Passo5"></a> Passo 5: Configurar gatilho do fluxo e conectar pipelines de CI/CD

  1. Retorne ao projeto clicando no 🍔 menu hambúrguer e acessando: **Developer Services**  → **Projects**.
  2. No canto esquerdo selecione **Triggers**, e em seguida clique em **Create Trigger**.

  ![](./Images/053-LAB4.png)

  3. Preencha o formulário como abaixo e clique em **Create**.
  - **Name**: Inicio
  - **Description**: (Defina uma descrição qualquer).
  - **Source connection**: OCI Code Repository
  - **Select code repository**: ftRepo
  - **Actions**: Add Action
    - **Select Build Pipeline**: build
    - **Event**: Push (check) 
    - **Source branch**: main

![](./Images/054-LAB4.png)

*A partir desse momento, qualquer novo push feito no repositório do projeto iniciará o pipeline de build criado nesse workshop*.

4. Retorne à configuração do pipeline de build do projeto selecionando **Build Pipelines** → **build**.

![](./Images/055-LAB4.png)

  5. Na aba de Build Pipeline, clique no sinal de **"+"** abaixo do stage **Entrega de Imagem de Container** e clique em **Add Stage**.

![](./Images/056-LAB4.png)

6. Selecione o item de **Trigger Deployment**, e clique em **Next**.

![](./Images/057-LAB4.png)

7. Preencha o formulário como abaixo e clique em **Add**.
- **Nome**: Inicio de Deployment
- **Description**: (Defina uma descrição qualquer).
- **Select deployment pipeline**: deploy

*Mantenha os demais campos sem alteração*.

![](./Images/058-LAB4.png)

Parabéns por chegar até aqui!! Nosso pipeline já está pronto! No próximo passo iremos validar o projeto, checando se está tudo ok.

 ## <a name="Passo6"></a> Passo 6: Execução e testes
  1.  Retorne ao projeto clicando no 🍔 menu hambúrguer e acessando: **Developer Services**  → **Projects**.
  2.  Retorne à configuração do pipeline de build do projeto selecionando **Build Pipelines** → **build**.
  
  ![](./Images/055-LAB4.png)

  3. No canto direito superior, selecione **Start Manual Run**.

![](./Images/055_1-LAB4.png)

  4. Mantenha as informações do formulário padrão, e clique em **Start Manual Run**.
  5. Aguarde a execução do fluxo.
  6. Acesse novamente o Cloud Shell e execute o comando abaixo.

  ```shell
  kubectl get svc
  ```

  7. Copie a informação de EXTERNAL-IP do serviço _svc-java-app_ assim que estiver disponível.

```shell
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)          AGE
kubernetes     ClusterIP      10.96.0.1       <none>            443/TCP          30h
svc-app        LoadBalancer   10.96.252.115   <svc-app-ip>   80:31159/TCP     29h
svc-java-app   LoadBalancer   10.96.16.229    <EXTERNAL-IP>   8081:32344/TCP   103m
```

  8. No **Cloud Shell**, execute o comando abaixo substituindo a informação de `<EXTERNAL-IP>` pelo IP copiado.

   ```shell
  curl --location --request POST '<EXTERNAL-IP>:8081/processcart' \
--header 'Content-Type: application/json' \
--data '[
      {   "nome":"Oranges",
      "preco":1.99
      },
      {   "nome":"Apples",
          "preco":2.97
      },
      {   "nome":"Bananas",
          "preco":2.99
      },
      {   "nome":"Watermelon",
          "preco":3.99
      }
]'
```
- Você deverá visualizar como resposta a soma dos preços dos produtos! Experimente modificar os valores para checar a soma!

![](./Images/059-LAB4.png)

### 👏🏻 Parabéns!!! Você foi capaz de construir com sucesso um pipeline completo de **DevOps** na OCI! 🚀
