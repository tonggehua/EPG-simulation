function display_seq(seq)
figure% figure number
hold on;
timing = seq.time;
uniqtimes = unique(timing);
grad = seq.grad;
rf = seq.rf;
subplot(2,1,1);
axis([0,timing(end),0,1.25]);title('RF')
subplot(2,1,2);
axis([0,timing(end),-1.25*max(abs(grad)),1.25*max(abs(grad))]);title('Gradients')
%axis([0,timing(end),min(grad),max(grad)]);title('Gradients')
rf_cnt = 1;
grad_cnt = 1;
for k = 1:length(seq.events)
    switch seq.events{k}
        case 'rf'
            subplot(2,1,1)
            line([timing(k),timing(k)],[0 1],'LineWidth',3)
            flip = rf(:,rf_cnt);
            rf_cnt = rf_cnt + 1;
            text(timing(k),1.1,['(',num2str(flip(1)), '^{\circ}', ... 
                ',',num2str(flip(2)),'^{\circ}',')'] ,'FontSize',10);
        case 'grad'
            subplot(2,1,2); hold on
            u = find(uniqtimes==timing(k));
            if grad(grad_cnt)>0
                    col = 'g';
            else
                    col = 'r';
            end
            area([uniqtimes(u-1),uniqtimes(u)],...
                [grad(grad_cnt),grad(grad_cnt)],'FaceColor',col)
            grad_cnt = grad_cnt + 1;
         
    end
end
end

