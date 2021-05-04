
select * from INFORMATION_SCHEMA.COLUMNS 
where COLUMN_NAME like '%proposal_freelancer%' and TABLE_SCHEMA = 'parodb_dev'
order by TABLE_NAME;

select DATABASE ();

-- Query 1: Join freelancer_proposal table with other related tables to gain insight

select proposal_freelancer_xref.proposal_ID as 'proposal id', freelancer_ID, active, 
proposal_freelancer_active_type.value as 'Accept/Reject/Active', proposal_freelancer_status_type.value,
project.name, project.id as 'project id', project.client_ID 
from proposal_freelancer_xref
left join (proposal_freelancer_active_type, proposal_freelancer_status_type, project)
on (proposal_freelancer_xref.active = proposal_freelancer_active_type.id
and proposal_freelancer_xref.proposal_freelancer_status_ID = proposal_freelancer_status_type.id
and project.proposal_ID = proposal_freelancer_xref.proposal_ID)
order by freelancer_ID, 'proposal id', 'project id', client_ID;

-- Query 2: Get the total number of proposals that each freelancer has submitted

select count(*) as 'total_proposals', freelancer_ID
from proposal_freelancer_xref
left join (proposal_freelancer_active_type, proposal_freelancer_status_type, project)
on (proposal_freelancer_xref.active = proposal_freelancer_active_type.id
and proposal_freelancer_xref.proposal_freelancer_status_ID = proposal_freelancer_status_type.id
and project.proposal_ID = proposal_freelancer_xref.proposal_ID)
group by freelancer_ID 
order by count(*) DESC;

-- Query 3:Extracting clients based on their industries
select count(*) as 'Number of clients', client.industry, industry.value 
from client 
left join industry
on client.industry = industry.ID
group by industry.ID
order by count(*) DESC;

-- Query 4: Freelancers based on their services
select count(*) as 'No_freelancers', freelancer.service_ID, service.value 
from freelancer 
left join service 
on freelancer.service_ID = service.ID 
group by freelancer.service_ID
order by count(*) DESC;

-- Query 5: Checking which account manager handles most clients
select count(client.name) as 'Number of clients', client.account_manager_ID, CONCAT(`user`.first_name, ' ', `user`.last_name) as 'Account manager'
from client 
left join `user` 
on client.account_manager_ID  = `user`.ID 
group by client.account_manager_ID 
order by account_manager_ID DESC 
;
-- Account manager id in client table has no matching account manager in account_manager table


-- Query 6: Freelancer and the number of projects completed
select count(project.ID) as 'Total_projects', proposal_freelancer_xref.freelancer_ID 
from project 
left join proposal on project.proposal_ID = proposal.ID  
left join proposal_freelancer_xref on project.proposal_ID = proposal_freelancer_xref.proposal_ID 
group by proposal_freelancer_xref.freelancer_ID 
order by count(project.ID) desc  
;

-- Query 7: Top 10 Clients based on revenue 
 
select client_ID, sum(amount) as 'Revenue', client.name from client_invoice
left join client 
on client_invoice.client_ID = client.ID
group by client_ID
order by sum(amount) DESC
limit 10;

-- Query 8: Type of users

select count(`user`.ID) as 'Total_number', `user`.user_type_ID, user_type.value
from `user`
left join user_type 
on `user`.user_type_ID = user_type.ID 
group by `user`.user_type_ID
;




