%% function ARGOreports()
% Input: 
% "argo_bio-profile_index.txt" 
% "ar_index_global_prof.txt"
% Output:
% ARGO Spatial Reports
% 	1. Unique WMO ID's during the specific time period.
%	2. CTD & BIO ARGO profiles distribution.
% 	3. Monthly Count of CTD & BIO ARGO Profiles.
% Author:   PAVAN KUMAR JONNAKUTI
%           Project Scientist - B
%           Data Information & Management Group
%           Indian National Centre for Ocean Information Services (INCOIS)
%           "Ocean Valley", Pragathi Nagar (B.O)
%           Nizampet (S.O), Hyderabad - 500 090
%           Telangana, INDIA
% E-mail:   jpawan33@gmail.com
% Web-link: http://jpavan.com
% Copyright @ Author
% code : Visualization of ARGO DATA

clc;clear all;close all;
%%
bd = readtable([pwd filesep 'argo_bio-profile_index.txt']);
bc = readtable([pwd filesep 'ar_index_global_prof.txt');

% xbd =  num2str(bd.date_update);
idx = bd.date>20181231235900;
bd = bd(idx,:);
xbd =  num2str(bd.date);
datesbd = datetime(str2num(xbd(:,1:4)),str2num(xbd(:,5:6)),str2num(xbd(:,7:8)),...
        str2num(xbd(:,9:10)),str2num(xbd(:,11:12)),str2num(xbd(:,13:14)));
% xbc =  num2str(bc.date_update);
idxx = bc.date>20181231235900;
bc = bc(idxx,:);
xbc =  num2str(bc.date);
datesbc = datetime(str2num(xbc(:,1:4)),str2num(xbc(:,5:6)),str2num(xbc(:,7:8)),...
        str2num(xbc(:,9:10)),str2num(xbc(:,11:12)),str2num(xbc(:,13:14)));
% Date filters 
startDate = datetime('02/01/2019 12:36:20','InputFormat','MM/dd/yyyy hh:mm:ss');
endDate = datetime('07/31/2019 12:36:20','InputFormat','MM/dd/yyyy hh:mm:ss');
idxbd = datesbd>startDate & datesbd<endDate;
idxbc = datesbc>startDate & datesbc<endDate;

dataBIOG = bd(idxbd,:);
dataCTDG = bc(idxbc,:);
datesbd = datesbd(idxbd);
datesbc = datesbc(idxbc);
% Filter Data for Indian Ocean 
% For Atlantic replace "I" with "A" & for pacific repace with "P"
instbdI = strcmpi(cellstr('I'),dataBIOG.ocean);
dataBIO = dataBIOG(instbdI,:);
instbcI = strcmpi(cellstr('I'),dataCTDG.ocean);
dataCTD = dataCTDG(instbcI,:);

datesbd = datesbd(instbdI);
datesbc = datesbc(instbcI);

%%
db = dataBIO; dc = dataCTD;
db.parameter_data_mode =[];db.parameters = [];
newtable = vertcat(db,dc);
files = split(newtable.file,'/');
[idxwbdc,ia,ib] = unique(files(:,2)) ;
% Search for DAC 
inst = strcmpi('incois',files(ia,1));
Lonbdc = zeros(size(idxwbdc,1),1); Latbdc = zeros(size(idxwbdc,1),1);
for iloop = 1:length(idxwbdc)
    idbd = find((strcmpi(cell2mat(idxwbdc(iloop)),files(:,2))));
    Lonbdc(iloop) = newtable.longitude(idbd(end));
    Latbdc(iloop) = newtable.latitude(idbd(end));
end
%%
ctd_count = zeros(6,1);
bio_count = zeros(6,1);
chla_count = zeros(6,1);
bbp_count = zeros(6,1);
for jloop=1:6
    ctd_count(jloop) = nnz(month(datesbc)==jloop+1) ;
    bio_count(jloop) = nnz(month(datesbd)==jloop+1) ;
end
figure
yyaxis left
plot(ctd_count,'b','Linewidth',3)
ylabel('No. of ARGO CTD Profiles')
hold on
yyaxis right
plot(bio_count,'r','Linewidth',3)
ylabel('No. of ARGO BIO Profiles')
xticks([1 2 3 4 5 6])
xticklabels({'FEB','MAR','APR','MAY','JUN','JUL'})
xtickangle(45)
legend('CTD','BIO');
%% CTD_BIO Profiles
figure
load coastlines.mat
plot(coastlon,coastlat,'k','Linewidth',3)
hold on
plot(dataCTD.longitude,dataCTD.latitude,'.r')
plot(dataBIO.longitude,dataBIO.latitude,'.b')
xlim([30 120])
ylim([-30 30])
legend('','CTD','BIO');
%% Unique WMOIDs
figure 
plot(coastlon,coastlat,'k','Linewidth',3)
hold on
plot(Lonbdc(inst==1),Latbdc(inst==1),'^b')
plot(Lonbdc(inst==0),Latbdc(inst==0),'^r')
% scatter(Lonbd,Latbd,15,inst,'filled')
% DAC specific Lat's & Lon's
xlim([30 120])
ylim([-30 30])
legend('','INCOIS','Others');


