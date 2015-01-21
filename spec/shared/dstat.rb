shared_examples 'dstat' do
  describe package 'dstat' do
    it { should be_installed }
  end
end

