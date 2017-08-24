function  [Tdiff] = IntergralLatency(condi1,condi2,sig)
% FEI YI - University of Glasgow - Augest 2017

% data ready

colo = [ 0.9020    0.5176    0.4784 ; 0    0.4196    0.7569 ];

norm1 = condi1 - min(condi1); norm2 = condi2 - min(condi2);
norm1 = norm1 ./ max(abs(norm1)); norm2 = norm2 ./ max(abs(norm2));

%%
% Fit model to data-----------------------------------
[xData, yData] = prepareCurveData( 1:size(norm1,2), norm1 );
[fitresult1, ~] = fit( xData, yData, 'linearinterp', 'Normalize', 'on' );
[xData, yData] = prepareCurveData( 1:size(norm2,2), norm2 );
[fitresult2, ~] = fit( xData, yData, 'linearinterp', 'Normalize', 'on' );

Vgap = (1-sig)/99;
time1 = 0; time2 = 0;
for g = 1:100
    % curves 1
    time1 = time1 + .001;
    while round(fitresult1(time1),4) - (sig + Vgap*(g-1)) <= 0.001
        time1 = time1 + .001;
        if time1 > 101
            break;
        end
    end
    Stime1(g)= time1;
    
    % curves 2
    time2 = time2 + .001;
    while round(fitresult2(time2),4) - (sig + Vgap*(g-1)) <= 0.001
        time2 = time2 + .001;
        if time2 > 101
            break;
        end
    end
    Stime2(g)= time2;
end
Tdiff = mean(Stime1(:) - Stime2(:));

%%
plot(norm1,'color',colo(1,:),'linestyle','--','LineWidth',1);hold on
plot(norm2,'color',colo(2,:),'linestyle','--','LineWidth',1);

for g = 1:100
    plot([round(Stime1(g)),round(Stime2(g))], ...
        [sig + Vgap*(g-1),sig + Vgap*(g-1)],'color',[.7 .7 .7]);hold on
end

set(gca,'ylim',[0 1.1],'xlim',[0,100],...
    'xTick',[0:25:100],'xTicklabel',[100 150 200 250 300],...
    'FontSize',12,'LineWidth',1,'Layer','Top')
box off

set(gcf,'renderer','painter');
set(gcf,'InvertHardCopy','off')
end
