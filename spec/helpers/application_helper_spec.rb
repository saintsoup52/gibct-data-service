RSpec.describe ApplicationHelper, type: :helper do
	let(:fullpath) { "/abc/def/ghi" }
	let(:rootpath) { "/" }
	let(:fullpath_link) { %Q(<li><a href="#{fullpath}">abc</a></li>) }
	let(:fullpath_active_link) { 
		%Q(<li class="active"><a href="#{fullpath}">abc <span class="sr-only">(current)</span></a></li>) 
	}

	describe "get_path" do
  	it "extracts the path from a full path" do
  		expect(helper.get_path(rootpath)).to eq(rootpath)
  		expect(helper.get_path(rootpath + "?a=b&c=d")).to eq(rootpath)
  		expect(helper.get_path(fullpath)).to eq(fullpath)
  		expect(helper.get_path(fullpath + "?a=b&c=d")).to eq(fullpath)
  	end

  	it "returns nil if the path is empty" do
  		expect(helper.get_path).to be_nil
  	end
  end

  describe "active_path?" do
  	it "returns false if either path or current_path are empty" do
  		expect(helper.active_path?(nil, fullpath)).to be_falsy
  		expect(helper.active_path?(fullpath, nil)).to be_falsy
  	end

  	it "returns true if path is nil and current_path is empty" do
  		expect(helper.active_path?(nil, "")).to be_truthy
  	end
  end

  describe "draw_link" do
  	it "returns a regular nav-bar link if the current_path is empty" do
  		expect(helper.draw_link(fullpath, "abc")).to eq(fullpath_link)
  	end
  	
  	it "returns a regular nav-bar link if the current_path doesn't match the path" do
  		expect(helper.draw_link(fullpath, "abc", rootpath)).to eq(fullpath_link)
  	end

  	it "returns an active nav-bar link if the current_path matches the path" do
  		expect(helper.draw_link(fullpath, "abc", fullpath)).to eq(fullpath_active_link)
  	end
  end
end