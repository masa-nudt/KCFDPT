% Use 2.0, 1.8, 1.6 as parameter to find out sequences with different scale variation levels
function find_scale_change_level_seqs(scale_exam_thres)

pathAnno = './anno/';
attPath = './anno/att/';
addpath('./util/');

seqs = configSeqs;

total_sc_variation = 0;
total_frame = 0;
count_variation_seqs = 0;

for idxSeq=1:length(seqs)
    s = seqs{idxSeq};
    
    att_anno = dlmread([attPath s.name '.txt']);
    % Make sure the sequence is annotated as "scale variation" in OTB
    if att_anno(3) == 0
        continue;
    end
  
    s.len = s.endFrame - s.startFrame + 1;
    s.s_frames = cell(s.len,1);

    rect_anno = dlmread([pathAnno s.name '.txt']);
    numSeg = 20;
    [subSeqs, subAnno]=splitSeqTRE(s,numSeg,rect_anno);
   
    anno=subAnno{1};
    
    count_sc_variation = 0;
    
    for i = 1 : size(anno,1)
        j = 1;
        j(i>30)  =  i-30 ;
        for k = j : i        
                if anno(i,3)*anno(i,4) > scale_exam_thres * anno(k,3)*anno(k,4) || anno(i,3)*anno(i,4) < 1/scale_exam_thres * anno(k,3)*anno(k,4)                  
                  count_sc_variation = count_sc_variation+1;
                  break;
                end
        end      
    end
    
    if count_sc_variation/size(anno,1) >= 0.1
        disp(s.name);
        total_sc_variation = total_sc_variation + count_sc_variation;
        count_variation_seqs = count_variation_seqs + 1;
        total_frame = total_frame + size(anno,1);
    end
end