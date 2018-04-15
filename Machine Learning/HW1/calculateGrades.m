%9 Optional Problem : calculateGrades

load classGrades

grades=namesAndGrades(:,2:end)

mean_score=mean(grades,2)

meanGrades=nanmean(grades)

meanMatrix=ones(15,1)*meanGrades

curvedGrades=3.5*(grades./meanMatrix)

curvedmeanGrades=nanmean(curvedGrades)

curvedGrades(find(curvedGrades > 5))=5

totalGrade=ceil(nanmean(curvedGrades,2))

letters='FDCBA'

letterGrades=letters(totalGrade)

disp(['Grades:',letterGrades])
