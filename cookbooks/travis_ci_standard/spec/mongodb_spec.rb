describe 'mongodb installation' do
  describe command('mongo --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/MongoDB shell/) }
  end

  describe 'mongo commands', sudo: true do
    before :all do
      system 'sudo service mongodb start'
      sleep 10
      system 'mongo --eval "db.testData.insert( { x : 6 } );"'
    end

    describe file('/var/log/mongodb/mongodb.log') do
      its(:content) { should match(/\[initandlisten\] waiting for connections on port/) }
    end

    describe command('mongo --eval "var myCursor = db.testData.find( { x: 6 }); myCursor.forEach(printjson);"') do
      its(:stdout) { should match(/{ "_id" : ObjectId\("[\w]+"\), "x" : 6 }/) }
    end
  end
end
