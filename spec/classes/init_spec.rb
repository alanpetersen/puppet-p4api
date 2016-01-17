require 'spec_helper'
describe 'p4api' do

  context 'with supported Linux 2.6 64-bit (e.g. Redhat 6)' do
    let(:facts) {{
        :kernel           => 'Linux',
        :kernelmajversion => '2.6',
        :architecture     => 'x86_64',
    }}
    it { should contain_class('p4api') }
  end

  context 'with supported Linux 3.16 64-bit (e.g. Ubuntu 14)' do
    let(:facts) {{
        :kernel           => 'Linux',
        :kernelmajversion => '3.16',
        :architecture     => 'amd64',
    }}
    it { should contain_class('p4api') }
  end


end
