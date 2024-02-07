## Build Prolamb with SWI Prolog

```
cd swipl
docker build --tag qvdk/prolamb:amazonlinux2023 -f build.Dockerfile . 
```

## Build Prolamb with Sicstus

```
cd sicstus
docker build --build-arg SITENAME='<your sitename>' --build-arg LICENSECODE='<your license>' --build-arg EXPIRES='<your expires>' --tag qvdk/prolamb:sicstus-amazonlinux2023 -f build.sicstus.Dockerfile .

docker build --build-arg SITENAME='Quentin Vandekerckhove' --build-arg LICENSECODE='cc4h-bdku-yknk-c2ph-cb6q' --build-arg EXPIRES='20240306' --tag qvdk/prolamb:sicstus-amazonlinux2023 -f build.sicstus.Dockerfile .
```

