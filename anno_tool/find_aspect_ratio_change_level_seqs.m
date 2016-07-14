% Use 1.6, 1.5, 1.4 as parameter to find out sequences with different aspect ratio variation levels
function find_aspect_ratio_change_level_seqs(aspect_ratio_exam_thres)

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
    
    count_ar_variation = 0;
    
    for i = 1 : size(anno,1)
        j = 1;
        j(i>30)  =  i-30 ;
        for k = j : i        
                if anno(i,3)/anno(i,4) > aspect_ratio_exam_thres * anno(k,3)/anno(k,4) || anno(i,3)/anno(i,4) < 1/aspect_ratio_exam_thres * anno(k,3)/anno(k,4)                  
                  count_ar_variation = count_ar_variation+1;
                  break;
                end
        end      
    end
    
    if count_ar_variation/size(anno,1) >= 0.1
        disp(s.name);
        total_ar_variation = total_ar_variation + count_ar_variation;
        total_frame = total_frame + size(anno,1);
    end
end
