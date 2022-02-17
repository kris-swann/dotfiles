

# See available docker-compose items
`docker-compose config --services`


# Debug celery task from debug shell
https://medium.com/@kennethjiang/debug-celery-tasks-in-ipdb-6f71506e6430
```
insert breakpoint in code, then:
task_to_debug.apply(args=[arg1, arg2], kwargs={'kwarg1': 'x', 'kwarg2': 'y'})

OR (more usefully):

ipdb.runcall(task_to_debug, arg1, arg2)
```
