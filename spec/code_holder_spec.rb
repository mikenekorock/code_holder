# -*- coding: utf-8 -*-
require 'spec_helper'

describe "CodeHolder" do
  describe "load" do
    it "できる" do
      C_TEST.gender.map{|k,v| v.data }.should == [{:key=>"FEMALE", :value=>"f", :position=>"2", :name=>"女性", :short_name=>"女", :int_val=>"2"}, {:key=>"MALE", :value=>"m", :position=>"1", :name=>"男性", :short_name=>"男", :int_val=>"1"}]
    end
  end

  describe "key名" do
    it "を渡すと、その行のvalueが返る" do
      C_TEST.gender.FEMALE.should == "f"
    end

    it ".nameとすると、表示名が表示される" do
      C_TEST.gender.FEMALE.name.should == "女性"
    end

    it ".column名とすると、指定した列の値が表示される" do
      C_TEST.gender.FEMALE.short_name.should == "女"
    end

    it ".positionとすると、ポジションがintegerで返る" do
      C_TEST.gender.FEMALE.position.should == 2
    end

    it "type,column,integer を宣言しておくとintegerで返る" do
      C_TEST.gender.FEMALE.int_val.should == 2
    end
  end

  describe "[value]" do
    it "を渡すと、その行のvalueが返る" do
      C_TEST.gender["m"].should == "m"
    end

    it ".nameとすると、表示名が表示される" do
      C_TEST.gender["m"].name.should == "男性"
    end

    it ".column名とすると、指定した列の値が返る" do
      C_TEST.gender["m"].short_name.should == "男"
    end

    it ".positionとすると、ポジションがintegerで返る" do
      C_TEST.gender["m"].position.should == 1
    end

    it "type,column,integer を宣言しておくとintegerで返る" do
      C_TEST.gender["m"].int_val.should == 1
    end

  end

  describe ".to_opt" do
    it "とすると[[name,value],...]の形でposition順の配列が返る" do
      C_TEST.gender.to_opt.should == [["男性","m"],["女性","f"]]
    end

    it "(column1)とすると、指定列の配列が返る" do
      C_TEST.gender.to_opt(:short_name).should == [["男", "m"], ["女", "f"]]
    end

    it "(column1, column2)とすると、指定列の配列が返る" do
      C_TEST.gender.to_opt(:name, :int_val).should == [["男性", 1], ["女性", 2]]
    end
  end
end
