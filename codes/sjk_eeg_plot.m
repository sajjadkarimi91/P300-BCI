function sjk_eeg_plot(EEG, srate, scale_factor)

if nargin <=2
    scale_factor = 3*std(EEG(:),[],'omitnan');
end

MyTime = linspace(0,size(EEG,2)/srate , size(EEG,2));
one_1 = ones(1,size(EEG,2));
% figure(100)
% grid on
hold off
n=1;
plot(MyTime , 2*(n-1)*scale_factor+EEG(n,:),'b','linewidth',2)
hold on
plot(MyTime , -2*(n-1)*scale_factor*one_1,'k')


for n=2:min(size(EEG , 1) , 256)

    plot(MyTime , -2*(n-1)*scale_factor+EEG(n,:),'b','linewidth',2)
    plot(MyTime , -2*(n-1)*scale_factor*one_1,'k')

end

grid on

ylim([min(-2*(n-1)*scale_factor+EEG(n,:)), 1.05*max(EEG(1,:))])