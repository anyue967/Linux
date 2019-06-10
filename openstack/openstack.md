## 1. 云计算的定义：
> 云计算是一种**按使用量付费**的模式，这种模式提供可用的、便捷的、按需的网络访问，进入可配置的计算资源共享池（资源包括网络、服务器、存储、应用软件、服务），这些资源能够被快速提供，只需投入很少的管理工作，或与服务供应商进行很少的交互。
## 2. openstack 组件说明：
> **Nova**（Computer）计算服务 **核心**   
**Glance**（Image Service）镜像服务  
**Cinder**（Block Storage）块存储服务  
**Neutron**（Networking）网络服务  
**Horizon**（Dashboard）仪表盘服务  
**Keystone**（Identity Service）认证服务  
**Heat**（Orchestration）编排服务  
**Ceilometer**（Telemetry）监控服务  
**Trove**（Database Service）数据库服务  
**Sahara**（Data Processing）数据库处理服务  
![openstack-IP](../base/img/openstack-IP.jpg)  
## 3. keystone 组件：
### 3.1 什么是keystone?
+ **Keystone**是  **OpenStack Identity Service** 的项目名称，是一个负责身份管理与授权的组件；实现用户的身份认证，基于角色的权限管理，及 openstack 其他组件的访问地址和安全策略管理
### 3.2 实现流程：
+ 用户管理
    * Account 账户
    * Authentication 身份认证
    * Authorization 授权
+ 服务目录管理
    * User：（用户）一个人、系统或服务在OpenStack中的数字表示。已经登录的用户分配令牌环以访问资源。用户可以直接分配给特定的租户，就像隶属于每个组；
    * Credentials：（凭证） 用于确认用户身份的数据。例如：用户名和密码，用户名和API key，或由认证服务提供的身份验证令牌；
    * Authentication：（验证） 确认用户身份的过程；
    * Token：（令牌） 一个用于访问OpenStack API和资源的字母数字字符串。一个临牌可以随时撤销，并且持续一段时间有效；
    * Tenant：（租户）一个组织或孤立资源的容器。租户和可以组织或隔离认证对象。根据服务运营的要求，一个租户可以映射到客户、账户、组织或项目；
    * Service：（服务）OpenStack服务，例如计算服务（nova），对象存储服务（swift）,或镜像服务（glance）。它提供了一个或多个端点，供用户访问资源和执行操作；
    * Endpoint：（端点）一个用于访问某个服务的可以通过网络进行访问的地址，通常是一个URL地址；
    * Role：（角色）定制化的包含特定用户权限和特权的权限集合；
    * Keystone Client：（keystone命令行工具） Keystone的命令行工具。通过该工具可以创建用户，角色，服务和端点等；
>用户：张三   
凭证 ：身份证  
验证：验证身份证  
令牌：房卡  
租户：宾馆  
服务：住宿、餐饮  
端点：路径  
角色：VIP等级   
## 3. Glance 组件：
+ openstack 镜像服务（glance）使用户能够发现、注册并检索虚拟机镜像；
+ 提供了 REST API 接口，使用户可以查询虚拟机镜像元数据和检索一个实际镜像文件
+ 默认情况下，上传的虚拟机镜像存储路径为/var/lib/glance/images/；
+ glance-api：一个用来接收镜像发现、检索和存储的API 接口；
+ glance-registry：用来存储、处理和检索镜像的元数据。元数据包含对象的大小和类型。glance-registry是一个OpenStack镜像服务使用的内部服务，不要透露给用户；
+ Database：用于存储镜像的元数据的大小、类型，支持大多数数据库，一般选择MySQL 或SQLite；
+ Storage repository for image files：镜像文件的存储仓库。支持包括普通文件系统在内的各种存储类型。包括对象存储、块设备、HTTP、Amazon S3，但有些存储只支持只读访问；




