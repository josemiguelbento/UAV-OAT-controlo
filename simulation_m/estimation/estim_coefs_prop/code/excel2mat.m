clear all
close all
clc

%filename1 = "../test_prop_xplane_2022/test_22-06-20_1824_vel_0_6_10";
%filename2 = "../test_prop_xplane_2022/test_22-06-20_1829_vel_15_20_25";
sheetname = 'sheet1';
filename = "../test_prop_xplane_2022/test_22-06-20_total";

opts = detectImportOptions(filename, 'sheet', sheetname);
data_raw = readtable(filename, opts);

columns_delete = {'Time', 'Ambient_Temp_DCVoltage_', 'Motor_Temp_DCVoltage_'};
data_raw = removevars(data_raw, columns_delete);

data_struct = table2struct(data_raw);
data_cell = struct2cell(data_struct);
new_fields = {'time', 'delta_t', 'V', 'I', 'load_cell', 'rpm', 'Va'};
data = cell2struct(data_cell,new_fields);

v0 = data(1:100);
v6 = data(129:198);
v10 = data(208:278);
v15 = data(279:391);
v20 = data(406:472);
v25 = data(488:541);

save('test_prop13x6.5_bat4s_v0.mat','v0');
save('test_prop13x6.5_bat4s_v6.mat','v6');
save('test_prop13x6.5_bat4s_v10.mat','v10');
save('test_prop13x6.5_bat4s_v15.mat','v15');
save('test_prop13x6.5_bat4s_v20.mat','v20');
save('test_prop13x6.5_bat4s_v25.mat','v25');