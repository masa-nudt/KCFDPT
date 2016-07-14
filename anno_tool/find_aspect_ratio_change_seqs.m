% Find out and annotate sequences with obvious aspect ratio variation
function find_aspect_ratio_change_seqs()

pathAnno = './anno/';
attPath = './anno/att/';
addpath('./util/');
seqs = configSeqs;

total_ar_variation = 0;
total_frame = 0;

for idxSeq=1:length(seqs)
    s = seqs{idxSeq};
     
    s.len = s.endFrame - s.startFrame + 1;
    s.s_frames = cell(s.len,1);

    rect_anno = dlmread([pathAnno s.name '.txt']);
    numSeg = 20;
    [subSeqs, subAnno]=splitSeqTRE(s,numSeg,rect_anno);
   
    anno=subAnno{1};
    
    aspect_ratio_att = 0;    
    count_ar_variation = 0;
    
    for i = 1 : size(anno,1)
        j = 1;
        j(i>30)  =  i-30 ;
        for k = j : i        
                if anno(i,3)/anno(i,4) > 1.4 * anno(k,3)/anno(k,4) || anno(i,3)/anno(i,4) < 1/1.4 * anno(k,3)/anno(k,4)                  
                  count_ar_variation = count_ar_variation+1;
                  break;
                end
        end      
    end
    
    if count_ar_variation/size(anno,1) >= 0.1
        aspect_ratio_att = 1;
        disp(s.name);
        total_ar_variation = total_ar_variation + count_ar_variation;
        total_frame = total_frame + size(anno,1);
    end
    
    % Uncomment the commented code below to write into annotation files. 
    % Use ONCE ONLY to prevent duplicate annotation.
%     att_anno = dlmread([attPath s.name '.txt']);
%     att_anno = [att_anno, aspect_ratio_att];
%     dlmwrite([attPath s.name '.txt'], att_anno);

end

disp([num2str(total_ar_variation) ' frames undergoing aspect ratio variation out of ' ...
    num2str(total_frame) ' total frames.']);
