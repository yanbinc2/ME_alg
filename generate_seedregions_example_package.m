%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate seed regions for an example MNIST dataset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;

directory='/mnt/sdb/NN/package_version3/data/';


% Load MNIST data and spectral cluster labels.

clustersfilename=sprintf('%sMNIST_SpectralLabel.csv',directory);


% Load t-SNE projection data.
datafilename=sprintf('%sMNIST_tSNE.csv',directory);
augdatafileinfoname='dummy';

% The parameter values are storted in a file.
parametersfilename=sprintf('%sMNIST_generate_seedregions_params.txt',directory);


% Load the input data.
filename=sprintf('%s',datafilename);
fp=fopen(filename,'r');
s=fgets(fp);
ndim=sum(s==',')+1;
fseek(fp,0,-1);
form=[repmat('%f',1,ndim)];
de=sprintf(',');
cells=textscan(fp,form,'Delimiter',de,'Headerlines',1,'TreatAsEmpty',{'NA','na'});
fclose(fp);
ndim=length(cells); nimages=length(cells{1});
data=NaN*ones(nimages,ndim);
for i=1:ndim
 data(:,i)=transpose(cells{i});
end


% Load the augmented data if the file exists.
filename=sprintf('%s',augdatafileinfoname);
fp=fopen(filename,'r');
if (fp<0)
 augdata=[];
else
 s=fgets(fp);
 augdirectory=s(1:(length(s)-1));
 s=fgets(fp);
 prefix=s(1:(length(s)-1));
 s=fgets(fp);
 naugmentations=atof2(s);
 fclose(fp);
 filename=sprintf('%s%s_001.csv',augdirectory,prefix);
 fp=fopen(filename,'r');
 if (fp<0)
  augdata=[];
 else
  fclose(fp);
  for ind=1:naugmentations
   str2=sprintf('%d',ind);
   l2=length(str2); l1=3-l2;
   str1=repmat('0',1,l1);
   str=sprintf('%s%s',str1,str2);
   filename=sprintf('%s%s_%s.csv',augdirectory,prefix,str);
   fp=fopen(filename,'r');
   form=[repmat('%f',1,ndim)];
   de=sprintf(',');
   cells=textscan(fp,form,'Delimiter',de,'Headerlines',1,'TreatAsEmpty',{'NA','na'});
   fclose(fp);
   augdata(:,:,ind)=NaN*ones(nimages,ndim);
   for i=1:ndim
    augdata(:,i,ind)=transpose(cells{i});
   end
  end
 end
end


% Load cluster labels of data points.
% Also load the true labels of data points.
% Find dominant class labels of regions.
filename=sprintf('%s',clustersfilename);
fp=fopen(filename,'r');
form=['%s','%d','%s'];
de=sprintf(',');
cells=textscan(fp,form,'Delimiter',de,'Headerlines',1,'TreatAsEmpty',{'NA','na'});
fclose(fp);
regionneighborlabels=cells{2};
regionneighborlabels=transpose(regionneighborlabels);
nregions=max(regionneighborlabels);


% Obtain class labels of images.
imagelabels=zeros(1,nimages);
ulabels={}; nulabels=0;
for n=1:nimages
 str=cells{3}{n};
 str=str(2:(length(str)-1));
 [a,b]=ismember(str,ulabels);
 if (b<=0)
  nulabels=nulabels+1;
  ulabels{nulabels}=str;
  imagelabels(n)=nulabels;
 else
  imagelabels(n)=b;
 end
end

% Sort the class labels and reorder imagelabels.
[Y,I]=sort(ulabels);
I=1:nulabels;
sortedulabels=ulabels(I);
sortedinds=zeros(1,nulabels);
for i=1:nulabels
 j=I(i); sortedinds(j)=i;
end

sortedimagelabels=zeros(1,nimages);
for n=1:nimages
 i=imagelabels(n);
 j=sortedinds(i);
 sortedimagelabels(n)=j-1;
end

imagelabels=sortedimagelabels;
clear sortedimagelabels;
ulabels=sortedulabels;
clear sortedulabels;


% Load parameter values from the parameter file.
vals=load(parametersfilename);
K=vals(1); filter=vals(2); theta=vals(3); theta2=vals(4); theta3=vals(5);
sizethre=vals(6); topthre=vals(7); nimagesthre=vals(8); mthre=vals(9); lwdthre=vals(10);
uppthre=vals(11); nmarkersthre=vals(12); rankthre=vals(13); rankratiothre=vals(14); disparitythre=vals(15);
overlapthre=vals(16); highthre=vals(17); dthre=vals(18); sharedthre=vals(19); nnbsthre=vals(20);
nvalidnbsthre=vals(21); rthre=vals(22); regionpairDmode=vals(23); maxnseeds=vals(24); ratiothre=vals(25);
foldthre=vals(26); nclassesthre=vals(27); diffratiothre=vals(28); nconsecutivesthre=vals(29); datamode=vals(30);



% Run generate_seedregions_package.m.
[nseeds,seedinds,bilabels,regionpairD]=generate_seedregions_package(data,augdata,data,datamode,regionneighborlabels,K,filter,theta,theta2,theta3,sizethre,topthre,nimagesthre,mthre,lwdthre,uppthre,nmarkersthre,rankthre,rankratiothre,disparitythre,overlapthre,highthre,dthre,sharedthre,nnbsthre,nvalidnbsthre,rthre,regionpairDmode,maxnseeds,ratiothre,foldthre,nclassesthre,diffratiothre,nconsecutivesthre);


% The seed indices and bilabels are stored in output files.
seedindsfilename=sprintf('%sMNIST_seedinds.txt',directory);
bilabelsfilename=sprintf('%sMNIST_bilabels.txt',directory);
nbregionsfilename=sprintf('%sMNIST_seedinds_neighborregions.txt',directory);


% Report seed indices.
filename=sprintf('%s',seedindsfilename);
fout=fopen(filename,'w');
for m=1:nseeds
 n=seedinds(m);
 fprintf(fout,'%d\n',n);
end
fclose(fout);


% Report bilabels.
filename=sprintf('%s',bilabelsfilename);
fout=fopen(filename,'w');
for i=1:nimages
 fprintf(fout,'%d%c%d\n',bilabels(i,1),9,bilabels(i,2));
end
fclose(fout);


% Report the top 6 neighboring regions of seed regions (including the seed regions themselves).

fout=fopen(nbregionsfilename,'w');
for m=1:nseeds
 n=seedinds(m);
 [Y,I]=sort(regionpairD(n,:),'ascend');
 for i=1:6
  fprintf(fout,'%d',I(i));
  if (i<6)
   fprintf(fout,'%c',9);
  end
 end
 fprintf(fout,'\n');
end
fclose(fout);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate seed regions for an example CIFAR10 dataset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear;

directory='/mnt/sdb/NN/package_version3/data/';


% Load VGG16 embeddings of CIFAR10 data and spectral cluster labels.

datafilename=sprintf('%sVGG16_CIFAR.csv',directory);

clustersfilename=sprintf('%sVGG16_CIFAR_SpectralLabel.csv',directory);


% Load the VGG outputs of 10 rounds of augmented CIFAR10 data.
augdatafileinfoname=sprintf('%sCIFAR10_augdatafileinfo.txt',directory);


% The parameter values are storted in a file.
parametersfilename=sprintf('%sCIFAR10_generate_seedregions_params.txt',directory);


% Load the input data.
filename=sprintf('%s',datafilename);
fp=fopen(filename,'r');
s=fgets(fp);
ndim=sum(s==',')+1;
fseek(fp,0,-1);
form=[repmat('%f',1,ndim)];
de=sprintf(',');
cells=textscan(fp,form,'Delimiter',de,'Headerlines',1,'TreatAsEmpty',{'NA','na'});
fclose(fp);
ndim=length(cells); nimages=length(cells{1});
data=NaN*ones(nimages,ndim);
for i=1:ndim
 data(:,i)=transpose(cells{i});
end


% Load the augmented data if the file exists.
filename=sprintf('%s',augdatafileinfoname);
fp=fopen(filename,'r');
if (fp<0)
 augdata=[];
else
 s=fgets(fp);
 augdirectory=s(1:(length(s)-1));
 s=fgets(fp);
 prefix=s(1:(length(s)-1));
 s=fgets(fp);
 naugmentations=atof2(s);
 fclose(fp);
 filename=sprintf('%s%s_001.csv',augdirectory,prefix);
 fp=fopen(filename,'r');
 if (fp<0)
  augdata=[];
 else
  fclose(fp);
  for ind=1:naugmentations
   str2=sprintf('%d',ind);
   l2=length(str2); l1=3-l2;
   str1=repmat('0',1,l1);
   str=sprintf('%s%s',str1,str2);
   filename=sprintf('%s%s_%s.csv',augdirectory,prefix,str);
   fp=fopen(filename,'r');
   form=[repmat('%f',1,ndim)];
   de=sprintf(',');
   cells=textscan(fp,form,'Delimiter',de,'Headerlines',1,'TreatAsEmpty',{'NA','na'});
   fclose(fp);
   augdata(:,:,ind)=NaN*ones(nimages,ndim);
   for i=1:ndim
    augdata(:,i,ind)=transpose(cells{i});
   end
  end
 end
end


% Load cluster labels of data points.
% Also load the true labels of data points.
% Find dominant class labels of regions.
filename=sprintf('%s',clustersfilename);
fp=fopen(filename,'r');
form=['%s','%d','%s'];
de=sprintf(',');
cells=textscan(fp,form,'Delimiter',de,'Headerlines',1,'TreatAsEmpty',{'NA','na'});
fclose(fp);
regionneighborlabels=cells{2};
regionneighborlabels=transpose(regionneighborlabels);
nregions=max(regionneighborlabels);


% Obtain class labels of images.
imagelabels=zeros(1,nimages);
ulabels={}; nulabels=0;
for n=1:nimages
 str=cells{3}{n};
 str=str(2:(length(str)-1));
 [a,b]=ismember(str,ulabels);
 if (b<=0)
  nulabels=nulabels+1;
  ulabels{nulabels}=str;
  imagelabels(n)=nulabels-1;
 else
  imagelabels(n)=b-1;
 end
end

% Sort the class labels and reorder imagelabels.
[Y,I]=sort(ulabels);
%I=1:nulabels;
sortedulabels=ulabels(I);
sortedinds=zeros(1,nulabels);
for i=1:nulabels
 j=I(i); sortedinds(j)=i;
end

sortedimagelabels=zeros(1,nimages);
for n=1:nimages
 i=imagelabels(n)+1;
 j=sortedinds(i);
 sortedimagelabels(n)=j-1;
end

imagelabels=sortedimagelabels;
clear sortedimagelabels;
ulabels=sortedulabels;
clear sortedulabels;



% Load parameter values from the parameter file.
vals=load(parametersfilename);
K=vals(1); filter=vals(2); theta=vals(3); theta2=vals(4); theta3=vals(5);
sizethre=vals(6); topthre=vals(7); nimagesthre=vals(8); mthre=vals(9); lwdthre=vals(10);
uppthre=vals(11); nmarkersthre=vals(12); rankthre=vals(13); rankratiothre=vals(14); disparitythre=vals(15);
overlapthre=vals(16); highthre=vals(17); dthre=vals(18); sharedthre=vals(19); nnbsthre=vals(20);
nvalidnbsthre=vals(21); rthre=vals(22); regionpairDmode=vals(23); maxnseeds=vals(24); ratiothre=vals(25);
foldthre=vals(26); nclassesthre=vals(27); diffratiothre=vals(28); nconsecutivesthre=vals(29); datamode=vals(30);



% Run generate_seedregions_package.m.
[nseeds,seedinds,bilabels,regionpairD]=generate_seedregions_package(data,augdata,data,datamode,regionneighborlabels,K,filter,theta,theta2,theta3,sizethre,topthre,nimagesthre,mthre,lwdthre,uppthre,nmarkersthre,rankthre,rankratiothre,disparitythre,overlapthre,highthre,dthre,sharedthre,nnbsthre,nvalidnbsthre,rthre,regionpairDmode,maxnseeds,ratiothre,foldthre,nclassesthre,diffratiothre,nconsecutivesthre);


% The seed indices and bilabels are stored in output files.
seedindsfilename=sprintf('%sCIFAR10_seedinds.txt',directory);
bilabelsfilename=sprintf('%sCIFAR10_bilabels.txt',directory);
nbregionsfilename=sprintf('%sCIFAR10_seedinds_neighborregions.txt',directory);


% Report seed indices.
filename=sprintf('%s',seedindsfilename);
fout=fopen(filename,'w');
for m=1:nseeds
 n=seedinds(m);
 fprintf(fout,'%d\n',n);
end
fclose(fout);


% Report bilabels.
filename=sprintf('%s',bilabelsfilename);
fout=fopen(filename,'w');
for i=1:nimages
 fprintf(fout,'%d%c%d\n',bilabels(i,1),9,bilabels(i,2));
end
fclose(fout);


% Report the top 6 neighboring regions of seed regions (including the seed regions themselves).

fout=fopen(nbregionsfilename,'w');
for m=1:nseeds
 n=seedinds(m);
 [Y,I]=sort(regionpairD(n,:),'ascend');
 for i=1:6
  fprintf(fout,'%d',I(i));
  if (i<6)
   fprintf(fout,'%c',9);
  end
 end
 fprintf(fout,'\n');
end
fclose(fout);



