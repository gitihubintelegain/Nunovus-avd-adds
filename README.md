<div align="center">

# ☁️ Nunovus Personal Azure Virtual Desktop Platform

### Enterprise Azure Virtual Desktop automation using Terraform, GitHub Actions, and Active Directory orchestration

Production-grade Personal Azure Virtual Desktop deployment with automated infrastructure provisioning, Active Directory integration, and staged deployment orchestration.

<br>

<p align="center">
  <img src="https://img.shields.io/badge/Azure-0078D4?style=flat-square&logo=microsoftazure&logoColor=white"/>
  <img src="https://img.shields.io/badge/Terraform-623CE4?style=flat-square&logo=terraform&logoColor=white"/>
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white"/>
  <img src="https://img.shields.io/badge/Windows_11-0078D6?style=flat-square&logo=windows11&logoColor=white"/>
  <img src="https://img.shields.io/badge/PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white"/>
</p>

<br>

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&color=0:0078D4,100:7C4DFF&height=130&section=header&text=Personal%20Azure%20Virtual%20Desktop&fontSize=32&fontColor=ffffff&animation=fadeIn"/>

</div>

---

<div align="center">

[Overview](#-overview) •
[Architecture](#-enterprise-architecture) •
[Networking](#-network-architecture) •
[Identity](#-identity--authentication) •
[CI/CD](#-cicd-pipeline) •
[Deployment](#-deployment-flow)

</div>

<br>

<div align="center">

| Environment | Host Pool Type | IaC | CI/CD | Platform |
|---|---|---|---|---|
| Production | Personal | Terraform | GitHub Actions | Azure Virtual Desktop |

</div>

---

# <img width="28" src="https://img.icons8.com/fluency/48/document.png"/> Overview

This repository contains a production-ready Personal Azure Virtual Desktop (AVD) platform built using Terraform, GitHub Actions, and Active Directory Domain Services automation.

The deployment architecture provisions and configures:

- Azure Virtual Desktop infrastructure
- Active Directory Domain Services
- Automated Domain Controller promotion
- Personal Host Pool architecture
- Dedicated session host deployment
- Automated AD domain join
- Azure Bastion connectivity
- Multi-stage deployment orchestration
- CI/CD-driven infrastructure automation

> [!NOTE]
> This repository is maintained within the official organization GitHub environment for customer infrastructure deployments and operational automation.

---

# <img width="28" src="https://img.icons8.com/fluency/48/goal.png"/> Platform Objectives

- Standardized Azure Virtual Desktop deployments
- Automated infrastructure provisioning
- Consistent deployment orchestration
- Reusable Terraform architecture
- Automated Active Directory integration
- Reliable dependency sequencing
- Production-ready infrastructure deployment
- Scalable Personal AVD architecture

---

# <img width="28" src="https://img.icons8.com/fluency/48/system-task.png"/> Enterprise Architecture

## High-Level Architecture

```text
                              ┌─────────────────────┐
                              │   GitHub Actions    │
                              │     CI/CD Pipeline  │
                              └──────────┬──────────┘
                                         │
                                         ▼

                        ┌────────────────────────────────┐
                        │ Terraform Infrastructure Deploy │
                        └────────────────┬───────────────┘
                                         │

                  ┌──────────────────────┴──────────────────────┐
                  ▼                                             ▼

      ┌────────────────────┐                     ┌────────────────────┐
      │  Azure Networking  │                     │ Active Directory   │
      │       (VNet)       │                     │ Domain Services    │
      └─────────┬──────────┘                     └─────────┬──────────┘
                │                                          │
                ▼                                          ▼

      ┌────────────────────┐                     ┌────────────────────┐
      │ Azure Bastion Host │                     │  Domain Controller │
      └────────────────────┘                     └─────────┬──────────┘
                                                           │
                                                           ▼

                                   ┌────────────────────────────────────┐
                                   │ Personal Azure Virtual Desktop     │
                                   │ Dedicated Session Hosts            │
                                   └────────────────────────────────────┘
```

<div align="center">

Built using reusable Terraform modules and staged infrastructure orchestration.

</div>

---

# <img width="28" src="https://img.icons8.com/fluency/48/monitor.png"/> Personal AVD Architecture

## Dedicated Desktop Design

This deployment uses a Personal Host Pool model with dedicated Windows 11 session hosts.

### Platform Characteristics

| Component | Configuration |
|---|---|
| Host Pool Type | Personal |
| Session Hosts | 7 |
| User Assignment | Dedicated |
| Load Balancer | Persistent |
| Max Sessions | 1 |
| Operating System | Windows 11 Enterprise |
| Session Host Disk | Premium SSD |
| ADDS Disk | Standard SSD |
| Authentication | Active Directory |
| Deployment Method | GitHub Actions |

> [!NOTE]
> Each user receives a dedicated persistent desktop session hosted on an individual Windows 11 Enterprise virtual machine.

---

# <img width="28" src="https://img.icons8.com/fluency/48/networking-manager.png"/> Network Architecture

## Azure Networking Layout

```text
10.0.0.0/16
│
├── 10.0.1.0/24 → AVD Session Hosts
├── 10.0.2.0/24 → Active Directory
├── 10.0.3.0/27 → Azure Bastion
└── 10.0.4.0/27 → GatewaySubnet
```

## Networking Components

| Component | Purpose |
|---|---|
| Virtual Network | Centralized Azure networking |
| AVD Subnet | Session host deployment |
| ADDS Subnet | Domain controller infrastructure |
| Azure Bastion | Secure administrative access |
| GatewaySubnet | VPN and future hybrid connectivity |

> [!NOTE]
> Separate subnets are maintained for workload isolation, simplified NSG management, and future hybrid identity integration.

---

# <img width="28" src="https://img.icons8.com/fluency/48/domain.png"/> Identity & Authentication

The platform automatically configures Active Directory Domain Services during deployment.

## Automated Identity Components

| Component | Purpose |
|---|---|
| Active Directory Domain Services | Centralized authentication |
| Domain Controller Promotion | Automated ADDS deployment |
| DNS Configuration | Internal name resolution |
| Automated Domain Join | Session host onboarding |
| Kerberos Authentication | Identity validation |

---

## Domain Join Workflow

```text
Deploy Domain Controller
        ↓
Configure DNS
        ↓
Wait For ADDS Stabilization
        ↓
Deploy Session Hosts
        ↓
Automatic Domain Join
        ↓
AVD Registration
        ↓
Host Pool Availability
```

> [!NOTE]
> Deployment orchestration includes stabilization checks to ensure reliable domain join operations and AVD registration sequencing.

---

# <img width="28" src="https://img.icons8.com/fluency/48/process.png"/> CI/CD Pipeline

GitHub Actions is used for staged infrastructure deployment orchestration.

## Deployment Workflow

```text
Terraform Validate
        ↓
Terraform Plan
        ↓
Deploy Network + ADDS
        ↓
Automatic Domain Controller Promotion
        ↓
Wait For Domain Services Stabilization
        ↓
Deploy Personal AVD Infrastructure
        ↓
Automatic Domain Join
        ↓
AVD Registration
```

---

## Deployment Method

Deployments are triggered manually using GitHub Actions Workflow Dispatch.

```text
GitHub
→ Actions
→ Run Workflow
```

This deployment model provides:

- Controlled production deployments
- Safer infrastructure operations
- Improved deployment visibility
- Easier troubleshooting
- Better operational consistency

---

# <img width="28" src="https://img.icons8.com/fluency/48/opened-folder.png"/> Repository Structure

```text
.
├── envs
│   └── prod
│       ├── main.tf
│       ├── variables.tf
│
├── .github
│   └── workflows
│       └── deploy.yml
│       └── destroy.yml
│
└── README.md
```

---

# <img width="28" src="https://img.icons8.com/fluency/48/settings.png"/> Reusable Terraform Modules

This deployment consumes reusable enterprise Terraform modules for:

| Module | Purpose |
|---|---|
| network | Azure networking |
| adds | Active Directory Domain Services |
| avd | Azure Virtual Desktop |

## Module Capabilities

- Multi-customer deployments
- Personal AVD environments
- Pooled AVD environments
- Dedicated session host deployments
- Shared desktop infrastructure
- Development and production environments

---

# <img width="28" src="https://img.icons8.com/fluency/48/toolbox.png"/> Technology Stack

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| Microsoft Azure | Cloud Platform |
| Azure Virtual Desktop | Desktop Virtualization |
| GitHub Actions | CI/CD Automation |
| PowerShell | Windows Automation |
| Active Directory Domain Services | Identity Platform |

---

# <img width="28" src="https://img.icons8.com/fluency/48/flash-on.png"/> Platform Features

## Infrastructure Automation

- Full Terraform-based provisioning
- Modular reusable architecture
- Automated infrastructure deployment
- Dependency-aware orchestration

---

## Identity Automation

- Automated ADDS deployment
- Automated Domain Controller promotion
- Automated DNS configuration
- Automated domain join operations

---

## Personal Desktop Architecture

- Dedicated session hosts
- Persistent desktop assignment
- Premium SSD-backed workloads
- Single-user desktop allocation

---

## Deployment Orchestration

- Multi-stage infrastructure deployment
- Stabilization-aware sequencing
- Reliable dependency orchestration
- CI/CD-driven operations

---

# <img width="28" src="https://img.icons8.com/fluency/48/idea.png"/> Planned Enhancements

- FSLogix Profile Containers
- Microsoft Entra Hybrid Identity
- Intune Integration
- Monitoring & Alerting
- Auto Scaling
- Health Checks
- Golden Image Automation

---

# <img width="28" src="https://img.icons8.com/fluency/48/administrator-male.png"/> Repository Ownership

This repository is maintained within the organization's official GitHub environment for customer infrastructure deployments and operational automation.

---

## Lead Implementation & Platform Engineering

**Darshan Thenge**  
Cloud Engineer | Azure Platform Engineering | Infrastructure Automation

Primary implementation responsibilities include:

- Azure Virtual Desktop platform deployment
- Terraform infrastructure automation
- Active Directory integration
- Automated domain join orchestration
- GitHub Actions CI/CD pipelines
- Deployment sequencing & infrastructure orchestration
- Personal AVD architecture implementation
<br>

### Core Stack
<p align="left">
  <img width="42" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg" />
  <img width="42" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg" />
  <img width="42" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg" />
  <img width="42" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/powershell/powershell-original.svg" />
  <img width="42" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/windows11/windows11-original.svg" />
</p>
<div align="center">
<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&color=0:0078D4,100:7C4DFF&height=70&section=footer"/>
</div>
