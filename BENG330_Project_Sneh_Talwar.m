%Sneh Talwar
%BENG 330 Project
%Vessel Mechanics
clear, close all

%% JSIM DATA: Pressure, Diameter, Wall Thickness, Total Stress, Strain
% Pressure is the intraluminal pressure
% Diameter is the vessel diameter
% WallThickness is the vessel wall thickness

% JSim data: Diameter(Pressure) units=um;
Diameter = [ 88.043 93.478 101.087 121.739 114.13 107.609 101.087 97.826 102.174 108.696 131.522 144.565 ];
Pressure = [ 10 15 20 40 60 80 100 120 140 160 180 200 ];

% JSim data: WallThickness(Pressure) units=um;
WallThickness = [ 9.885809915 9.409372381 8.809267351 7.491319409 7.931306241 8.348776826 8.809267351 9.057571577 8.729278462 8.276361905 6.989358906 6.412260983 ];

% JSim data: TotalStress(Pressure) units=kilopascal;
TotalStress = [ 5.936844469 9.933747333 15.29884371 43.33157766 57.55452094 68.7367233 76.49421853 86.39664183 109.2353435 140.077108 225.7910182 300.5765261 ];

% JSim data: Strain(Pressure) units=dimensionlesss;
Strain = [ 1.039268349 1.103423631 1.193241025 1.437019292 1.347201898 1.270227364 1.193241025 1.154747856 1.206072082 1.28305842 1.552498799 1.706459672 ];

figure;
plot(Pressure, Diameter); title('Pressure v Diameter'); xlabel('Intraluminal Pressure (mmHg)'); ylabel('Diameter (microns)');
figure;
plot(Pressure, WallThickness); title('Pressure v WallThickness'); xlabel('Intraluminal Pressure (mmHg)'); ylabel('Wall Thickness (microns)');
figure;
plot(Pressure, TotalStress);  title('Pressure v TotalStress'); xlabel('Intraluminal Pressure (mmHg)'); ylabel('Stress (kPa)');
figure;
plot(Strain, TotalStress); title('Strain v Stress'); xlabel('Strain'); ylabel('Stress (kPa)');
%% Model numerical parameters - Rat femoral parameters!
Cp1 = 1.416; %mmHg
Cp2 = 7.901;
Dp100 = 172.8;%mmHg - diameter of the vessel in a passive state at 100 mmHg
Cmyo = 3.881; %determines the sensitivity of the VSM activation function to circumferential tension
Ctone = 8.871;
Ca1 = 1.499; %peak active tension
Ca2 = 0.742; %diameter of the peak active stress normalized by the passive vessel diameter at 100 mmHg 
Ca3 = 0.353; %width of the Gaussian normalized by Dp100.  


% TRANSFER FUNCTION 
SigTot = (Pressure.*Diameter)./(2.*WallThickness); 

SigPass = (Cp1./WallThickness) .* exp(Cp2 * ((Diameter./Dp100) - 1));
Act = 1 ./ (1 + exp(-Cmyo.*SigTot .* WallThickness + Ctone)); %the degree of activation of the VSM (range from 0 to 1), approximated by a sigmoidal function
SigActMax = (Ca1./WallThickness) .* exp(-1*(((Diameter./Dp100) - Ca2)./Ca3).^2);

SigTot = SigPass + (Act .* SigActMax);

figure;
plot(SigTot)

%% Simulink model of transfer function
sim('BENG330_Sneh_Talwar_sim')
figure;
plot(ans.simout) 
title('SigTot for Rat femoral artery'); xlabel('Time (mins)'); ylabel('SigTot');

% for R = [10 100 1000]
%    sim('BENG330_HW2_Sneh_Talwar_sim')
%    plot(ans.simout) 
%    hold on;
% end





