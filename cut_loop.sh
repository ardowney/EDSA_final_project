mkdir particle_analyzer_data_edited
cd "EAB JLR 1_3_18"
mv *.xls ../particle_analyzer_data_edited
cd ../particle_analyzer_data_edited

for old in *.xls
do
new=$(echo $old | sed 's/\.$ls.xls/.txt/' | sed 's/it /_R/' | sed 's/it/_R/' | sed 's/ wet/w/' | sed 's/ air/a/' | sed 's/ 2/2/' | sed 's/ spl_R/ R/'| sed 's/_spl_R/ R/'| sed 's/ /_/g')
mv "$old" "$new"
done


for file in *.txt
do
sed -i -e '1,30d;32d;33d' $file
done

rm *-e
ls *.txt | cut -d . -f 1 > ../dataframe_list.txt

ls *.txt | cut -d _ -f 1,2 > ../replication_list.txt
