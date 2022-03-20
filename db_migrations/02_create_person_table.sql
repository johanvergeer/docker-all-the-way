create table "Person"
(
    id            bigserial
        constraint person_pk
            primary key,
    "Name"        varchar(100) not null,
    "DateOfBirth" date         not null,
    "Email"       varchar(100) not null
);

create unique index person_email_uindex
    on "Person" ("Email");

create unique index person_id_uindex
    on "Person" (id);
