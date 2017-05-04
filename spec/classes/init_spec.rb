require 'spec_helper'
describe 'osrepos_wrapper' do
  describe 'with default values for all parameters' do
    # apt needs lsbdistid, swrepo needs lsbmajdistrelease
    os_default_matrix = {
      'Debian'  => { :os => 'Debian',  :lsbdistid => 'Debian', :lsbmajdist => nil,  :repoclass => 'apt' },
      'RedHat'  => { :os => 'RedHat',  :lsbdistid => nil,      :lsbmajdist => nil,  :repoclass => 'swrepo' },
      'Suse'    => { :os => 'Suse',    :lsbdistid => nil,      :lsbmajdist => '11', :repoclass => 'swrepo' },
      'Ubuntu'  => { :os => 'Debian',  :lsbdistid => 'Ubuntu', :lsbmajdist => nil,  :repoclass => 'apt' },
      'Unknown' => { :os => 'Unknown', :lsbdistid => nil,      :lsbmajdist => nil,  :repoclass => nil },
    }

    os_default_matrix.sort.each do |os, facts|
      context "when running on #{os} osfamily" do
        let(:facts) do
          {
            :osfamily          => facts[:os],
            :lsbdistid         => facts[:lsbdistid],
            :lsbmajdistrelease => facts[:lsbmajdist],
          }
        end
        it { should compile.with_all_deps }
        it { should contain_class('osrepos_wrapper') }
        if facts[:repoclass] != nil
          it { should contain_class(facts[:repoclass]) }
        end
      end
    end
  end

  describe 'with repoclass set to valid string otherclass on RedHat osfamily' do
    let :pre_condition do
      'class otherclass { }'
    end
    let(:params) { { :repoclass => 'otherclass' } }
    it { should compile.with_all_deps }
    it { should contain_class('osrepos_wrapper') }
    it { should contain_class('otherclass') }
    it { should_not contain_class('apt') }
    it { should_not contain_class('swrepo') }
  end

  describe 'variable type and content validations' do
    mandatory_params = {}
    let :pre_condition do
      'class string { }'
    end
    validations = {
      'string' => {
        :name    => %w[repoclass],
        :valid   => ['string'],
        :invalid => [%w[array], { 'ha' => 'sh' }, 3, 2.42, true],
        :message => 'is not a string',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
