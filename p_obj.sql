CREATE TABLE P_OBJ
(
   ID                  NUMBER (38) CONSTRAINT P_OBJ_ID_NN NOT NULL,
   P_OTYPE_ID          NUMBER (38) CONSTRAINT P_OBJ_P_OTYPE_ID_NN NOT NULL,
   OWNER               VARCHAR2 (30 CHAR) CONSTRAINT P_OBJ_OWNER_NN NOT NULL,
   NAME                VARCHAR2 (30 CHAR) CONSTRAINT P_OBJ_TABLE_NAME_NN NOT NULL,
   ENABLED             NUMBER (1) DEFAULT 0 CONSTRAINT P_OBJ_ENABLED_NN NOT NULL,
   ORDER#              NUMBER (19),
   LAST_RUN_START_TS   TIMESTAMP (6) WITH LOCAL TIME ZONE,
   LAST_RUN_END_TS     TIMESTAMP (6) WITH LOCAL TIME ZONE,
   last_run_duration   INTERVAL DAY TO SECOND
                          GENERATED ALWAYS AS (last_run_end_ts - last_run_start_ts)
)
TABLESPACE &DATA_TBS.;

COMMENT ON TABLE P_OBJ IS 'Partitioned object';

COMMENT ON COLUMN P_OBJ.ID IS 'Technical unique identifier';

COMMENT ON COLUMN P_OBJ.P_OTYPE_ID IS 'Reference to P_OTYPE.';

COMMENT ON COLUMN P_OBJ.OWNER IS 'Name of the object owner';

COMMENT ON COLUMN P_OBJ.NAME IS 'Name of the object';

COMMENT ON COLUMN P_OBJ.ENABLED IS 'Partition handling enabled';

COMMENT ON COLUMN P_OBJ.ORDER# IS
   'Order number in which the objects will be handled';

CREATE SEQUENCE P_OBJ_ID_SEQ START WITH 1000 INCREMENT BY 1 NOCACHE ORDER;

CREATE UNIQUE INDEX P_OBJ_ID_UX
   ON P_OBJ (ID)
   TABLESPACE &INDEX_TBS.;


CREATE UNIQUE INDEX P_OBJ_P_OTYPE_ID_OWNER_NAME_UX
   ON P_OBJ (P_OTYPE_ID, OWNER, NAME)
   TABLESPACE &INDEX_TBS.;

ALTER TABLE P_OBJ ADD
  CONSTRAINT P_OBJ_ENABLED_CK
  CHECK (enabled IN (0, 1))
  ENABLE VALIDATE;

ALTER TABLE P_OBJ ADD   CONSTRAINT P_OBJ_PK
  PRIMARY KEY
  (ID)
  USING INDEX P_OBJ_ID_UX
  ENABLE VALIDATE;

ALTER TABLE P_OBJ ADD  CONSTRAINT P_OBJ_P_OTYPE_ID_OWNER_NAME_UK
  UNIQUE (P_OTYPE_ID, OWNER, NAME)
  USING INDEX P_OBJ_P_OTYPE_ID_OWNER_NAME_UX
  ENABLE VALIDATE;

ALTER TABLE P_OBJ ADD (
  CONSTRAINT P_OBJ_P_OTYPE_FK
  FOREIGN KEY (P_OTYPE_ID)
  REFERENCES P_OTYPE (ID)
  ENABLE VALIDATE);