package spacelift

import rego.v1

# Trigger policy for vps-ansible stack
# Triggers when ansible/ or stacks/ directories are modified

track contains affected_file if {
    some affected_file in input.pull_request.diff
    startswith(affected_file, "ansible/")
}

track contains affected_file if {
    some affected_file in input.pull_request.diff
    startswith(affected_file, "stacks/")
}

# Also trigger on push events
track contains affected_file if {
    some affected_file in input.push.affected_files
    startswith(affected_file, "ansible/")
}

track contains affected_file if {
    some affected_file in input.push.affected_files
    startswith(affected_file, "stacks/")
}
