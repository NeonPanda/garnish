require 'spec_helper'

describe Garnish::Collection do

  let(:relation) { stub(:relation) }
  let(:template) { stub(:template) }
  let(:collection) { Garnish::Collection.new(relation, template) }

  it "should init with a relation record" do
    collection.relation.should eq(relation)
  end

  describe "the each method" do
    let(:array) { stub(:array, :each => nil) }
    before { collection.stub(:convert => array) }

    it "should call to_a" do
      relation.should_receive(:to_a).and_return(array)
      collection.each
    end

    it "should call each on the resulting array" do
      relation.stub(:to_a => array)
      array.should_receive(:each)
      collection.each
    end
  end

  it "should pass the to_a method to the relation" do
    relation.should_receive(:to_a)
    collection.to_a
  end

  describe "method chains should return the existing collection" do
    it "should be the same collection" do
      relation.stub(:limit => collection)
      collection.limit(1).should eq(collection)
    end

    it "should be the same collection" do
      relation.stub(:limit => collection, :order => collection)
      collection.limit(1).order(:desc).should eq(collection)
    end
  end
end
