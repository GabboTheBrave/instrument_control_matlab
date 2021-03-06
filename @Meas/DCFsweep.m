function wout=DCFsweep(obj, freq, pow, ch, varargin)

% This functions allows to make a frequency sweep for the energy harvester
% (EH) testing. FREQ is a vector with the frequencies of the sweep, POW is
% the power in dBm, ch is a vector with the oscilloscope's channels to record
% if varargin is passed, it has to be an function to apply to signals.

    obj.osc.setTimeScale(obj.EHtimeScale)
    fwrite(obj.osc.interfObj, 'run')
    obj.tek.setPower(pow)
    
    obj.osc.setBWLimit(ch)
    
    for i = 1:length(freq)
        
        obj.tek.setFreq(freq(i))
        
        for j=1:length(ch)

            [t(j,:), w(j,:)] = obj.osc.getChannel(ch(j));
            
            med(j,i)=sum(w(j,:))/length(w(j,:));
            
        end
    
    end
    
    if ~isempty(varargin)

        fun=varargin{1};

        for i=1:length(freq)
           
            wout(i)=feval(fun,arrayfun(@(x) med(x,i),ch));

        end

    else

        wout=med(1,:);
        
    end

%     plot(freq/1e6, wout*1e3)

%     graphEditing('Voltage across the capacitor vs. frequency', 'Frequency, [MHz]', 'Voltage, [mV]')

end