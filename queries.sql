select count(*) from user_entity
where realm_id = 'stix';

select count(*) from user_entity
where realm_id = 'stix' and enabled;

select count(*) from user_entity
where realm_id = 'stix' and not enabled;

select count(*) from user_entity ue
inner join user_attribute ua on ue.id = ua.user_id and ua.name = 'registration_complete'
where ua.value = 'T' and realm_id = 'stix';

select count(*) from user_entity ue
inner join user_attribute ua on ue.id = ua.user_id and ua.name = 'registration_complete'
where ua.value != 'T' and realm_id = 'stix';

select count(*) from user_entity ue
left join user_attribute ua on ue.id = ua.user_id and ua.name = 'registration_complete'
where ua.value is null and realm_id = 'stix';

-- EC

-- Usuarios ativos no mês

select count(*) from user_entity ue
left join user_attribute ua on ue.id = ua.user_id and ua.name = 'registration_complete'
where ua.value is null and realm_id = 'stix';