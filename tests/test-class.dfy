enum Status {
    Initialized,
    Running,
    Paused,
    Stopped
}

class StatefulObject {
    var status: Status

    // Class Invariant: status must always be one of the defined Status values
    invariant status == Status.Initialized || status == Status.Running ||
              status == Status.Paused || status == Status.Stopped

    // Constructor
    constructor()
        ensures status == Status.Initialized
    {
        status := Status.Initialized
    }

    // Method to start the object
    method Start()
        requires status == Status.Initialized || status == Status.Paused
        ensures status == Status.Running
    {
        status := Status.Running
    }

    // Method to pause the object
    method Pause()
        requires status == Status.Running
        ensures status == Status.Paused
    {
        status := Status.Paused
    }

    // Method to stop the object
    method Stop()
        requires status != Status.Stopped
        ensures status == Status.Stopped
    {
        status := Status.Stopped
    }

    // Method to get the current status
    method GetStatus() returns (currentStatus: Status)
        reads this
    {
        currentStatus := status
    }
}

method Main() {
    var obj := new StatefulObject();
    assert obj.GetStatus() == Status.Initialized;

    obj.Start();
    assert obj.GetStatus() == Status.Running;

    obj.Pause();
    assert obj.GetStatus() == Status.Paused;

    obj.Start();
    assert obj.GetStatus() == Status.Running;

    obj.Stop();
    assert obj.GetStatus() == Status.Stopped;

    // The following line would cause a verification error because you cannot start a stopped object
    // obj.Start();
}