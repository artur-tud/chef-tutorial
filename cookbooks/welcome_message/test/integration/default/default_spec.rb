describe 'welcome_message::default' do
    describe file('/etc/motd') do
        it { should exist }
        it { should be_a_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:mode) { should cmp '0644' }
        its('content') { should match '^\s+<\s+Hello!\s+>$' }
    end
end
