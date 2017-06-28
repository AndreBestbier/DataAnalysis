function [NexusPPG, NexusRSP] = loadNexus()

    fileID = fopen('Nexus.txt');
    C = textscan(fileID,'%f,%f,%c%s');
    fclose(fileID);
    A = cell2mat(C(:,1:2));
    M = cell2mat(C(:,3));
    Marker = 0;

    for i=1:length(M)
      if M(i) == 'M'
         Marker = i;
      end
    end

    NexusPPG = A(Marker:length(M), 1);
    NexusRSP = A(Marker:length(M), 2)-600;
    
end