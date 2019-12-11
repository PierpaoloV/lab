%% Script

close all
clc
fprintf("\nreading the images\n")
% images = zeros(353,354,3);
im1 =im2double(rgb2gray(imread('brain1.png')));
im2 = im2double(rgb2gray(imread('brain2.png')));
tic
tic 
fprintf("\nrigid, no sequence, sd ,one layer\n")
d1r = boh(im1,im2, 'r', 'sd', 1);
t_1 = toc;

tic
fprintf("\nrigid, no sequence, sd ,one layer\n")
d2r = boh(im1,im2, 'r', 'sd', 2);
t_2 = toc;

tic
fprintf("\nrigid, no sequence, sd, three layer\n")
d3r = boh(im1,im2, 'r', 'sd', 3);
t_3 = toc;

tic 
fprintf("\nrigid, no sequence, sd ,one layer\n")
d4r = boh(im1,im2, 'r', 'sd', 4);
t_14 = toc;

tic
fprintf("\naffine, no sequence, sd, one layer\n")
d1a = boh(im1,im2, 'a', 'sd', 1);
t_4 = toc;

tic
fprintf("\nrigid, no sequence, sd ,one layer\n")
d2a = boh(im1,im2, 'a', 'sd', 2);
t_5 = toc;

tic
fprintf("\naffine, no sequence, sd, three layer\n")
d3a = boh(im1,im2, 'a', 'sd', 3);
t_6 = toc;

tic
fprintf("\naffine, no sequence, sd, one layer\n")
d4a = boh(im1,im2, 'a', 'sd', 4);
t_44 = toc;

tic
fprintf("\nrigid, sequence, sd ,one layer\n")
d1r2 = boh2(im1,im2, 'r', 'sd', 1);
t_7 = toc;

tic
fprintf("\nrigid, sequence, sd ,one layer\n")
d2r2 = boh2(im1,im2, 'r', 'sd', 2);
t_8 = toc;

tic
fprintf("\nrigid, sequence, sd, three layer\n")
d3r2 = boh2(im1,im2, 'r', 'sd', 3);
t_9 = toc;

tic
fprintf("\nrigid, sequence, sd ,one layer\n")
d4r2 = boh2(im1,im2, 'r', 'sd', 4);
t_74 = toc;

tic
fprintf("\naffine, sequence, sd, one layer\n")
d1a2 = boh2(im1,im2, 'a', 'sd',1);
t_10 = toc;

tic
fprintf("\nrigid, no sequence, sd ,one layer\n")
d2a2 = boh2(im1,im2, 'a', 'sd', 2);
t_11 = toc;

tic
fprintf("\naffine, sequence, sd, three layer\n")
d3a2 = boh2(im1,im2, 'r', 'sd', 3);
t_12 = toc;
tic
fprintf("\naffine, sequence, sd, one layer\n")
d4a2 = boh2(im1,im2, 'a', 'sd',4);
t_104 = toc;
d_sd = [d1r d2r d3r d4r;
        d1a d2a d3a d4a;
        d1r2 d2r2 d3r2 d4r2;
        d1a2 d2a2 d3a2 d4a2];

times = [t_1 t_2 t_3 t_14;
        t_4 t_5 t_6 t_44;
        t_7 t_8 t_9 t_74;
        t_10 t_11 t_12 t_104];
clear d1r d2r d3r d1a d2a d3a d1r2 d2r2 d3r2 d1a2 d2a2 d3a2 d4r d4a d4r2 d4a2
clear t_1 t_2 t_3 t_4 t_5 t_6 t_7 t_8 t_9 t_10 t_11 t_12 t_14 t_44 t_74 t_104   
tic 
fprintf("\nrigid, no sequence, cc ,one layer\n")
c1r = boh(im1,im2, 'r', 'cc', 1);
ct_1 = toc;

tic
fprintf("\nrigid, no sequence, cc ,two layer\n")
c2r = boh(im1,im2, 'r', 'cc', 2);
ct_2 = toc;

tic
fprintf("\nrigid, no sequence, cc, three layer\n")
c3r = boh(im1,im2, 'r', 'cc', 3);
ct_3 = toc;

tic 
fprintf("\nrigid, no sequence, cc ,one layer\n")
c4r = boh(im1,im2, 'r', 'cc', 4);
ct_14 = toc;
tic
fprintf("\naffine, no sequence, cc, one layer\n")
c1a = boh(im1,im2, 'a', 'cc', 1);
ct_4 = toc;

tic
fprintf("\nrigid, no sequence, cc ,two layer\n")
c2a = boh(im1,im2, 'a', 'cc', 2);
ct_5 = toc;

tic
fprintf("\naffine, no sequence, cc, three layer\n")
c3a = boh(im1,im2, 'a', 'cc', 3);
ct_6 = toc;

tic
fprintf("\naffine, no sequence, cc, one layer\n")
c4a = boh(im1,im2, 'a', 'cc', 4);
ct_44 = toc;

tic
fprintf("\nrigid, sequence, cc ,one layer\n")
c1r2 = boh2(im1,im2, 'r', 'cc', 1);
ct_7 = toc;

tic
fprintf("\nrigid, sequence, cc ,two layer\n")
c2r2 = boh2(im1,im2, 'r', 'cc', 2);
ct_8 = toc;

tic
fprintf("\nrigid, sequence, cc, three layer\n")
c3r2 = boh2(im1,im2, 'r', 'cc', 3);
ct_9 = toc;

tic
fprintf("\nrigid, sequence, cc ,one layer\n")
c4r2 = boh2(im1,im2, 'r', 'cc', 4);
ct_74 = toc;

tic
fprintf("\naffine, sequence, cc, one layer\n")
c1a2 = boh2(im1,im2, 'a', 'cc',1);
ct_10 = toc;

tic
fprintf("\nrigid, no sequence, cc ,two layer\n")
c2a2 = boh2(im1,im2, 'a', 'cc', 2);
ct_11 = toc;

tic
fprintf("\naffine, sequence, cc, three layer\n")
c3a2 = boh2(im1,im2, 'r', 'cc', 3);
ct_12 = toc;
tic
fprintf("\naffine, sequence, cc, one layer\n")
c4a2 = boh2(im1,im2, 'a', 'cc',4);
ct_104 = toc;
d_cc = [c1r c2r c3r c4r;
        c1a c2a c3a c4a;
        c1r2 c2r2 c3r2 c4r2;
        c1a2 c2a2 c3a2 c4a2]; 
    
times_cc = [ct_1 ct_2 ct_3 ct_14;
        ct_4 ct_5 ct_6 ct_44;
        ct_7 ct_8 ct_9 ct_74;
        ct_10 ct_11 ct_12 ct_104]; 
clear c1r c2r c3r c1a c2a c3a c1r2 c2r2 c3r2 c1a2 c2a2 c3a2 c4a c4r c4r2 c4a2
clear ct_1 ct_2 ct_3 ct_4 ct_5 ct_6 ct_7 ct_8 ct_9 ct_10 ct_11 ct_12 ct_14 ct_44 ct_74 ct_104
tic 
fprintf("\nrigid, no sequence, gcc ,one layer\n")
nc1r = boh(im1,im2, 'r', 'gcc', 1);
nct_1 = toc;

tic
fprintf("\nrigid, no sequence, gcc ,two layer\n")
nc2r = boh(im1,im2, 'r', 'gcc', 2);
nct_2 = toc;

tic
fprintf("\nrigid, no sequence, gcc, three layer\n")
nc3r = boh(im1,im2, 'r', 'gcc', 3);
nct_3 = toc;

tic 
fprintf("\nrigid, no sequence, gcc ,one layer\n")
nc4r = boh(im1,im2, 'r', 'gcc', 4);
nct_14 = toc;

tic
fprintf("\naffine, no sequence, gcc, one layer\n")
nc1a = boh(im1,im2, 'a', 'gcc', 1);
nct_4 = toc;

tic
fprintf("\nrigid, no sequence, gcc ,two layer\n")
nc2a = boh(im1,im2, 'a', 'gcc', 2);
nct_5 = toc;

tic
fprintf("\naffine, no sequence, gcc, three layer\n")
nc3a = boh(im1,im2, 'a', 'gcc', 3);
nct_6 = toc;

tic
fprintf("\naffine, no sequence, gcc, one layer\n")
nc4a = boh(im1,im2, 'a', 'gcc', 4);
nct_44 = toc;

tic
fprintf("\nrigid, sequence, gcc ,one layer\n")
nc1r2 = boh2(im1,im2, 'r', 'gcc', 1);
nct_7 = toc;

tic
fprintf("\nrigid, sequence, gcc ,two layer\n")
nc2r2 = boh2(im1,im2, 'r', 'gcc', 2);
nct_8 = toc;

tic
fprintf("\nrigid, sequence, gcc, three layer\n")
nc3r2 = boh2(im1,im2, 'r', 'gcc', 3);
nct_9 = toc;

tic
fprintf("\nrigid, sequence, gcc ,one layer\n")
nc4r2 = boh2(im1,im2, 'r', 'gcc', 4);
nct_74 = toc;

tic
fprintf("\naffine, sequence, gcc, one layer\n")
nc1a2 = boh2(im1,im2, 'a', 'gcc',1);
nct_10 = toc;

tic
fprintf("\nrigid, no sequence, gcc ,two layer\n")
nc2a2 = boh2(im1,im2, 'a', 'gcc', 2);
nct_11 = toc;

tic
fprintf("\naffine, sequence, gcc, three layer\n")
nc3a2 = boh2(im1,im2, 'r', 'gcc', 3);
nct_12 = toc;
tic
fprintf("\naffine, sequence, gcc, one layer\n")
nc4a2 = boh2(im1,im2, 'a', 'gcc',1);
nct_104 = toc;

d_ncc = [nc1r nc2r nc3r nc4r;
        nc1a nc2a nc3a nc4a;
        nc1r2 nc2r2 nc3r2 nc4r2;
        nc1a2 nc2a2 nc3a2 nc4a2];    
times_gcc = [nct_1 nct_2 nct_3 nct_14;
        nct_4 nct_5 nct_6 nct_44;
        nct_7 nct_8 nct_9 nct_74;
        nct_10 nct_11 nct_12 nct_104];
clear nc1r nc2r nc3r nc1a nc2a nc3a nc1r2 nc2r2 nc3r2 nc1a2 nc2a2 nc3a2 nc4r nc4a nc4r2 nc4a2
clear nct_1 nct_2 nct_3 nct_4 nct_5 nct_6 nct_7 nct_8 nct_9 nct_10 nct_11 nct_12 nct_14 nct_44 nct_74 nct_104
toc