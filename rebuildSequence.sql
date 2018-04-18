declare
    TYPE MAP IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    v_tbl_seq MAP;
    tbl_var varchar2(100);
    seq_var varchar2(100);
    seq_exist_var int;
    max_id_var number;
    sql_var varchar2(500);
begin
    v_tbl_seq('pcic_timer_job') := 'seq_timer_job';
    v_tbl_seq('pcic_icd_map') := 'seq_pcic_icd_map';
    v_tbl_seq('mdi_rest_map') := 'seq_rest_map';
    v_tbl_seq('mdi_rest_router') := 'seq_rest_router';
    v_tbl_seq('pcic_hosiptal_map') := 'seq_pcic_hosiptal_map';
    v_tbl_seq('pcic_large_item_code_map') := 'seq_pcic_large_item_code_map';
    
    tbl_var := v_tbl_seq.FIRST;
    WHILE tbl_var IS NOT NULL LOOP
        seq_var := v_tbl_seq(tbl_var);
        SELECT COUNT(1) INTO seq_exist_var from user_sequences where lower(sequence_name)=seq_var;
        if seq_exist_var > 0 then
            sql_var := 'drop sequence '||seq_var;
            EXECUTE IMMEDIATE sql_var;
        end if;
        
        sql_var := 'select max(id)+1 from '||tbl_var;
        EXECUTE IMMEDIATE sql_var INTO max_id_var;
        
        sql_var := 'CREATE SEQUENCE '||seq_var||' minvalue 1 maxvalue 99999999999 start with '||max_id_var||' increment by 1 cache 20 cycle order';
        EXECUTE IMMEDIATE sql_var;
        
        tbl_var := v_tbl_seq.NEXT(tbl_var);
    END LOOP;
end;