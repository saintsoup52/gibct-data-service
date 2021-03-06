class CreateIpedsIcPies < ActiveRecord::Migration
  def change
    create_table :ipeds_ic_pies do |t|
      # Used in the building of DataCsv
      t.string :cross, null: false
      t.integer :tuition_in_state
      t.integer :tuition_out_of_state
      t.integer :books

      # Not used in building DataCsv, but used in exporting source csv
      t.integer :prgmofr
      t.float :cipcode1
      t.string :xciptui1
      t.integer :ciptuit1
      t.string :xcipsup1
      t.integer :cipsupp1
      t.string :xciplgt1
      t.integer :ciplgth1
      t.integer :prgmsr1
      t.string :xmthcmp1
      t.integer :mthcmp1
      t.string :xwkcmp1
      t.integer :wkcmp1
      t.string :xlnayhr1
      t.integer :lnayhr1
      t.string :xlnaywk1
      t.integer :lnaywk1
      t.string :xchg1py0
      t.integer :chg1py0
      t.string :xchg1py1
      t.integer :chg1py1
      t.string :xchg1py2
      t.integer :chg1py2
      t.string :xchg1py3
      t.integer :chg1py3
      t.string :xchg4py0
      t.integer :chg4py0
      t.string :xchg4py1
      t.integer :chg4py1
      t.string :xchg4py2
      t.integer :chg4py2
      t.string :xchg4py3
      t.string :xchg5py0
      t.integer :chg5py0
      t.string :xchg5py1
      t.integer :chg5py1
      t.string :xchg5py2
      t.integer :chg5py2
      t.string :xchg5py3
      t.integer :chg5py3
      t.string :xchg6py0
      t.integer :chg6py0
      t.string :xchg6py1
      t.integer :chg6py1
      t.string :xchg6py2
      t.integer :chg6py2
      t.string :xchg6py3
      t.integer :chg6py3
      t.string :xchg7py0
      t.integer :chg7py0
      t.string :xchg7py1
      t.integer :chg7py1
      t.string :xchg7py2
      t.integer :chg7py2
      t.string :xchg7py3
      t.integer :chg7py3
      t.string :xchg8py0
      t.integer :chg8py0
      t.string :xchg8py1
      t.integer :chg8py1
      t.string :xchg8py2
      t.integer :chg8py2
      t.string :xchg8py3
      t.integer :chg8py3
      t.string :xchg9py0
      t.integer :chg9py0
      t.string :xchg9py1
      t.integer :chg9py1
      t.string :xchg9py2
      t.integer :chg9py2
      t.string :xchg9py3
      t.integer :chg9py3
      t.float :cipcode2
      t.string :xciptui2
      t.integer :ciptuit2
      t.string :xcipsup2
      t.integer :cipsupp2
      t.string :xciplgt2
      t.integer :ciplgth2
      t.integer :prgmsr2
      t.string :xmthcmp2
      t.integer :mthcmp2
      t.float :cipcode3
      t.string :xciptui3
      t.integer :ciptuit3
      t.string :xcipsup3
      t.integer :cipsupp3
      t.string :xciplgt3
      t.integer :ciplgth3
      t.integer :prgmsr3
      t.string :xmthcmp3
      t.integer :mthcmp3
      t.float :cipcode4
      t.string :xciptui4
      t.integer :ciptuit4
      t.string :xcipsup4
      t.integer :cipsupp4
      t.string :xciplgt4
      t.integer :ciplgth4
      t.integer :prgmsr4
      t.string :xmthcmp4
      t.integer :mthcmp4
      t.float :cipcode5
      t.string :xciptui5
      t.integer :ciptuit5
      t.string :xcipsup5
      t.integer :cipsupp5
      t.string :xciplgt5
      t.integer :ciplgth5
      t.integer :prgmsr5
      t.string :xmthcmp5
      t.integer :mthcmp5
      t.float :cipcode6
      t.string :xciptui6
      t.integer :ciptuit6
      t.string :xcipsup6
      t.integer :cipsupp6
      t.string :xciplgt6
      t.integer :ciplgth6
      t.integer :prgmsr6
      t.string :xmthcmp6
      t.integer :mthcmp6
      t.timestamps null: false
    end
  end
end
